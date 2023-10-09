//
//  SingleContact.swift
//  ContactsList
//
//  Created by Ангелина Решетникова on 09.10.2023.
//

import Foundation
import SwiftUI
import ContactsUI
struct SingleContact: View {

    @State var contact: PhoneContact
    let unnamed = "Unnamed"

    var body: some View {
        VStack {
            avatarImage()
            Text(contact.name)
                .font(.system(size: 25))
                .fontWeight(.semibold)
            List {
                ForEach(contact.phoneNumber.keys.sorted(), id: \.self) { phone in
                    PhoneCell(contact: contact, phone: phone, isSelected: false)
                        .listRowInsets(EdgeInsets())
                }
            }
            .listStyle(.insetGrouped)
        }


    }
    
    @ViewBuilder
    func avatarImage() -> some View {
        if let avatarImage = contact.avatarImage {
            Image(uiImage: avatarImage)
                .resizable()
                .frame(width: 70, height: 70)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(20)
        } else {
            ZStack {
                defaultImage
                Text(contact.name.prefix(1))
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
        }
    }
    
    var defaultImage: some View {
        Circle()
            .fill()
            .foregroundColor(Colors.defaultAvatarBackground)
        .frame(width: 70, height: 70)
    }
    
        
}
    



struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        SingleContact(contact: PhoneContact(name: "Angelina Reshetnikova", phoneNumbers: [ "8 900 637 33 94": false, "+7 321 890 66 66": false]))
    }
}
