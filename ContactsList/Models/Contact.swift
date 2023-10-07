//
//  Contact.swift
//  ContactsList
//
//  Created by Ангелина Решетникова on 04.10.2023.
//

import Foundation
import ContactsUI

final class PhoneContact: Identifiable {

    let id = UUID()
    var name: String?
    var avatarImage: UIImage?
    var phoneNumber: [String] = [String]()
    var isSelected: Bool = false
    
    init(contact: CNContact) {
        if contact.givenName.count + contact.familyName.count == 0 {
            name = nil
        } else {
            name = contact.givenName + " " + contact.familyName
        }
        
        if let avatarData = contact.thumbnailImageData, let avatarImage = UIImage(data: avatarData) {
            self.avatarImage = avatarImage
        }
        
        for phone in contact.phoneNumbers {
            let digitsOnly = phone.value.stringValue.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
            
            //регулярное выражение для номера телефона
            let formattedNumber = digitsOnly.replacingOccurrences(of: "(\\d{1})(\\d{3})(\\d{3})(\\d{2})(\\d{2})", with: "+7 $2 $3 $4 $5", options: .regularExpression)
            
            phoneNumber.append(formattedNumber)
        }
    }
}

struct SortedContacts: Identifiable {
    let firstLetter: String
    let contacts: [PhoneContact]
    let id = UUID()
}
