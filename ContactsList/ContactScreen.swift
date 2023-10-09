//
//  ContentView.swift
//  ContactsList
//
//  Created by Ангелина Решетникова on 04.10.2023.
//

import SwiftUI

struct ContactsScreen: View {
    @StateObject var state: ContactsListState
    
    @State private var singleSelection: UUID?
    @Environment(\.dismiss) var dismiss
    @Binding var selected: [String]
    @State private var searchText: String = ""
    @State private var isSearchBarPresented = false
    @State private var showSearchBar = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0, content: {
                switch state.status {
                case .loading:
                    Text("loading")
                case .empty:
                    Text("empty")
                case .loaded(let contacts):
                    ZStack(alignment: .bottom) {
                        ScrollView {
                            LazyVStack(alignment: .leading, spacing: 0) {
                                ForEach(contacts.keys.sorted(), id: \.self) { key in
                                    Section(header: Text(key)
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 8))
                                    ) {
                                        ForEach(contacts[key] ?? []) { contact in
                                            if contact.phoneNumber.count > 1 {
                                                ContactListCell(contact: contact, isSelected: false, cellStyle: .multiNumber)
                                            } else {
                                                ContactListCell(contact: contact, isSelected: false, cellStyle: .singleNumber)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        Button(action: {
                            selected = contacts.values.flatMap({$0}).flatMap({$0.phoneNumber}).filter({$0.value == true}).map({$0.key})
                            dismiss()
                        }) {
                            selectButton
                        }
                        .padding(.horizontal, 16)
                    }
                case .error(let error):
                    Text(error.localizedDescription)
                }
            })
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.inline)
            //.searchable(text: $searchText, isPresented: $showSearchBar, promt: "Поиск")
            .searchable(text: $searchText, prompt: "Поиск") {
                if searchResults.isEmpty {
                    Text("Нет результатов по запросу \(searchText)")
                }
                ForEach(searchResults) { contact in
                    if contact.phoneNumber.count > 1 {
                        ContactListCell(contact: contact, isSelected: false, cellStyle: .multiNumber).searchCompletion(contact)
                            .listRowInsets(EdgeInsets())
                    } else {
                        ContactListCell(contact: contact, isSelected: false, cellStyle: .singleNumber).searchCompletion(contact)
                            .listRowInsets(EdgeInsets())
                    }
                }
                .listStyle(.plain)
                
            }
            .navigationBarItems(leading:
            HStack {
                Button("Close") {
                    selected = []
                    dismiss()
                }
            }, trailing:
            HStack {
                
                Button(action: {
                    showSearchBar.toggle()
                }) {
                    searchButton
                }
            }
            )
        }
        .onAppear(perform: { state.onAppear() })
    }
    
    private var selectButton: some View {
        HStack(alignment: .center) {
            Spacer()
            Text("Выбрать")
                .foregroundColor(.white)
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .frame(height: 52)
            Spacer()
        }
        .background(Colors.selectButtonBackground)
        .cornerRadius(12)
    }
    
    private var searchButton: some View {
        Image("searchImage")
            .resizable()
            .frame(width: 24, height: 24)
    }
    
    var searchResults: [PhoneContact] {
        if !searchText.isEmpty {
            return state.contacts.values.flatMap({$0}).filter({$0.name.contains(searchText) || $0.phoneNumber.keys.reduce("", +).contains(searchText)})
        } else {
            return []
        }
    }
}
