//
//  Onboarding.swift
//  Little Lemon
//
//  Created by Christian Pedersen on 20/06/2023.
//

import SwiftUI

let kIsLoggedIn = "isLoggedInKey"

let kFirstName = "firstNameKey"
let kLastName = "lastNameKey"
let kEmail = "emailKey"

struct Onboarding: View {
    @State var isLoggedIn = false
    
    @State var displayError = false
    @State var errorMessage = ""
    
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 20) {
                NavigationLink(destination: Home(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                
                CustomTextField(placeholder: "First Name", text: $firstName)
                CustomTextField(placeholder: "Last Name", text: $lastName)
                CustomTextField(placeholder: "Email", text: $email)
                
                Button("Register") {
                    if firstName.isEmpty {
                        errorMessage = "You must enter your first name."
                    } else if lastName.isEmpty {
                        errorMessage = "You must enter your last name."
                    } else if email.isEmpty {
                        errorMessage = "You must enter your email."
                    } else if !isValidEmail(email) {
                        errorMessage = "Please enter a valid email."
                    } else {
                        errorMessage = ""
                    }
                    
                    if errorMessage.isEmpty {
                        UserDefaults.standard.set(firstName, forKey: kFirstName)
                        UserDefaults.standard.set(lastName, forKey: kLastName)
                        UserDefaults.standard.set(email, forKey: kEmail)
                        
                        UserDefaults.standard.set(true, forKey: kIsLoggedIn)
                        
                        isLoggedIn = true
                    } else {
                        displayError = true
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color("Primary"))
                .cornerRadius(5.0)
                .foregroundColor(.white)
            }
            .padding()
            .onAppear {
                if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                    isLoggedIn = true
                }
            }
            .alert(isPresented: $displayError) {
                Alert(title: Text("Validation Error"), message: Text(errorMessage))
            }
        }
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let validator = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", validator)
        
        return predicate.evaluate(with: email)
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(.gray.opacity(0.05))
            .cornerRadius(5.0)
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        Onboarding()
    }
}
