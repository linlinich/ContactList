//
//  ContactsListState.swift
//  ContactsList
//
//  Created by Ангелина Решетникова on 04.10.2023.
//
import SwiftUI


@MainActor
final class ContactsListState: ObservableObject {
    
    
    //MARK: - Properties
    
    @Published var contacts = [String: [PhoneContact]]()
    @State private var multiSelection = Set<UUID>()
    @State private var singleSelection: UUID?
    
    //MARK: - State
    
    enum Status {
        case empty
        case loaded(contacts: [String: [PhoneContact]])
        case loading
        case error(Error)
        
        var isShimmering: Bool {
            switch self {
            case .loading: return true
            default: return false
            }
        }
    }
    
    enum PossibilityOfChoice {
        case single
        case multi
    }

    @Published var status: Status = .loading
    
    //MARK: - Navigations
    
    
    //MARK: - Services
    
    var contactsService = PhoneContactsService()
    
    //MARK: - Init
    
    
    //MARK: - Internal methods
    
    func onAppear() {
        // можно проверять показывался ли уже экран
        Task(priority: .high) {
            await fetchMasters()
        }
    }
    
    //MARK: - Private methods
    
    private func fetchMasters() async {
        status = .loading
        do {
            contacts = try contactsService.loadContacts()
            if contacts.isEmpty {
                status = .empty
            } else {
                status = .loaded(contacts: contacts)
            }
        } catch {
            status = .error(error)
        }
    }
}
