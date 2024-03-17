import Foundation
import FirebaseAuth

struct UserAuthInfo {
    let id: String
    let name: String?
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.id = user.uid
        self.email = user.email
        self.name = user.displayName
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init () {}
    
    func getAuthenticatedUser() throws -> UserAuthInfo {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noResponse
        }
        
        return UserAuthInfo(user: user)
    }
    
    @discardableResult
    func signInWithApple(tokens: SignInWithAppleResult) async throws -> (UserAuthInfo, isNewUser: Bool) {
        let credential = OAuthProvider.appleCredential(withIDToken: tokens.token,
                                                       rawNonce: tokens.nonce,
                                                       fullName: tokens.fullName)
        
        let authDataResult = try await signIn(credential: credential)
        let isNewUser = authDataResult.additionalUserInfo?.isNewUser ?? true
        
        var firebaserUser = authDataResult.user
        if isNewUser {
            if let updatedUser = try await updateUserProfile(
                displayName: tokens.fullName.formatted(),
                firstName: tokens.fullName.givenName,
                lastName: tokens.fullName.familyName,
                photoUrl: nil
            ) {
                firebaserUser = updatedUser
            }
        }
        
        let user = UserAuthInfo(user: firebaserUser)
        return (user, isNewUser)
    }
    
    func signIn(credential: AuthCredential) async throws -> AuthDataResult {
        let authDataResult = try await Auth.auth().signIn(with: credential)
        
        return authDataResult
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        try await user.delete()
    }
    
    private func updateUserProfile(displayName: String?, firstName: String?, lastName: String?, photoUrl: URL?) async throws -> User? {
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        
        var didMakeChanges: Bool = false
        if let displayName {
            request?.displayName = displayName
            didMakeChanges = true
        }
        
        if let firstName {
            UserDefaults.auth.firstName = firstName
        }
        
        if let lastName {
            UserDefaults.auth.lastName = lastName
        }
        
        if let photoUrl {
            request?.photoURL = photoUrl
            didMakeChanges = true
        }
        
        if didMakeChanges {
            try await request?.commitChanges()
        }
        
        return Auth.auth().currentUser
    }
    
    private enum AuthError: LocalizedError {
        case noResponse
        case userNotFound
        
        var errorDescription: String? {
            switch self {
            case .noResponse:
                return "Bad response."
            case .userNotFound:
                return "Current user not found."
            }
        }
    }
}

extension UserDefaults {
    static let auth = UserDefaults(suiteName: "auth_defaults")!
    
    func reset() {
        firstName = nil
        lastName = nil
    }
    
    var firstName: String? {
        get {
            self.value(forKey: "first_name") as? String
        }
        set {
            self.setValue(newValue, forKey: "first_name")
        }
    }
    
    var lastName: String? {
        get {
            self.value(forKey: "last_name") as? String
        }
        set {
            self.setValue(newValue, forKey: "last_name")
        }
    }
}
