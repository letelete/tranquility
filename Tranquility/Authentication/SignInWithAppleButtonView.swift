import SwiftUI
import _AuthenticationServices_SwiftUI

struct SignInWithAppleButtonView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        SignInWithAppleButtonViewRepresentable(type: .continue, style: colorScheme == .dark ? .white : .black).frame(height: 44).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
    }
}

struct SignInWithAppleButtonViewRepresentable: UIViewRepresentable {
    let type: ASAuthorizationAppleIDButton.ButtonType
    let style: ASAuthorizationAppleIDButton.Style
    
    
    
    func makeUIView(context: Context) -> some UIView {
        return ASAuthorizationAppleIDButton(authorizationButtonType: type, authorizationButtonStyle: style)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}


#Preview {
    SignInWithAppleButtonView()
}
