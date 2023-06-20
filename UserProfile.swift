//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Christian Pedersen on 20/06/2023.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    
    let firstName = UserDefaults.standard.string(forKey: kFirstName)
    let lastName = UserDefaults.standard.string(forKey: kLastName)
    let email = UserDefaults.standard.string(forKey: kEmail)
    
    var body: some View {
        VStack {
            Text("Personal Information")
            Image("profile-image-placeholder")
            
            Text(firstName ?? "")
            Text(lastName ?? "")
            Text(email ?? "")
            
            Button("Logout") {
                UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                self.presentation.wrappedValue.dismiss()
            }
            
            Spacer()
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
