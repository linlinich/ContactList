//
//  MainScreen.swift
//  ContactsList
//
//  Created by Ангелина Решетникова on 07.10.2023.
//

import Foundation
import SwiftUI
import SwiftUINavigation


struct MainScreen: View {
    
    @State private var isShowingPopover = false
    @State var selected: [String] = []

    
    var body: some View {
        Button("Show Popover") {
            self.isShowingPopover = true
        }
        .popover(isPresented: $isShowingPopover) {
            ContactsScreen(state: ContactsListState(), selected: $selected)
        }
        
        ForEach($selected, id: \.self) { phone in
            Text(phone.wrappedValue)
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
