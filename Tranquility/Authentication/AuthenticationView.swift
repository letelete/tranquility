import SwiftUI
import _AuthenticationServices_SwiftUI
import AuthenticationServices
import CryptoKit
import Foundation
import CryptoKit
import AuthenticationServices
import UIKit

@MainActor
final class AuthenticationViewModel: NSObject, ObservableObject {
    fileprivate var currentNonce: String?
    @Published var didSignWithApple: Bool = false
    
    func signInApple() async throws {
            startSignInWithAppleFlow()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    @available(iOS 13, *)
    func startSignInWithAppleFlow() {
        guard let topVC = UIApplication.shared.topViewController() else {
            return
        }
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = topVC
        authorizationController.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
}


struct SignInWithAppleResult {
    let token: String
    let nonce: String
    let fullName: PersonNameComponents
    
    init?(credential: ASAuthorizationAppleIDCredential, nonce: String) {
        guard
            let idToken = credential.identityToken,
            let idTokenString = String(data: idToken, encoding: .utf8),
            let fullName = credential.fullName
        else { return nil }
        
        self.token = idTokenString
        self.nonce = nonce
        self.fullName = fullName
    }
}

@available(iOS 13.0, *)
extension AuthenticationViewModel: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard
            let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
            let nonce = currentNonce,
            let tokens = SignInWithAppleResult(credential: appleIDCredential, nonce: nonce) else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        
        Task {
            do {
                try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
                didSignWithApple = true
            } catch {
                
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple errored: \(error)")
    }
    
}

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tranquility")
                .font(.subheadline)
                .fontWeight(.bold)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .center)
            VStack(alignment: .leading) {
                Text("One more step")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Connect your account to bring tranquility into your finances.")
                    .font(.body)
                    .foregroundStyle(.secondary).padding(.top, 1)
            }.padding(.top, 48)
            Spacer()
            Button {
                Task {
                    do {
                        try await viewModel.signInApple()
                        
                    } catch {
                        print(error)
                    }
                }
            } label: {
                SignInWithAppleButtonView().allowsHitTesting(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
            }
        }.padding().frame(maxWidth: .infinity, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/).onChange(of: viewModel.didSignWithApple) {
            oldState, newState in
            if newState {
                showSignInView = false
            }
        }
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
