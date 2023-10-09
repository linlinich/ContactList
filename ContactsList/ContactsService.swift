//
//  ContactsProcessor.swift
//  ContactsList
//
//  Created by Ангелина Решетникова on 04.10.2023.
//

import Foundation
import ContactsUI

class PhoneContactsService {
    
    func getContacts(filter: ContactsFilter = .none) throws -> [CNContact] { //  ContactsFilter is Enum find it below
        
        let contactStore = CNContactStore()
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey,
            CNContactEmailAddressesKey,
            CNContactThumbnailImageDataKey] as [Any]
        
        var allContainers: [CNContainer] = []
        do {
            allContainers = try contactStore.containers(matching: nil)
        } catch {
            throw FetchingContactThrows.accessError
        }
        
        var results: [CNContact] = []
        
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try contactStore.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                results.append(contentsOf: containerResults)
            } catch {
                throw FetchingContactThrows.conversationError
            }
        }
        return results
    }
    
    enum ContactsFilter {
        case none
    }
    
    func loadContacts(filter: ContactsFilter = .none) throws -> [String: [PhoneContact]] {
        var allContacts = [String: [PhoneContact]]()
        do {
            let contacts = try getContacts(filter: filter)
            for contact in contacts {
                if !contact.phoneNumbers.isEmpty {
                    let contact = PhoneContact(contact: contact)
                    allContacts[String(contact.name.uppercased().prefix(1)), default: []].append(contact)
                }
            }
            return allContacts
        } catch {
            throw error
        }
    }
}

enum FetchingContactThrows: String, Error {
    case accessError
    case conversationError
}
