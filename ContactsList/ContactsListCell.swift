//
//  ContactsListCell.swift
//  ContactsList
//
//  Created by Ангелина Решетникова on 05.10.2023.
//

import Foundation
import SwiftUI
import Contacts

enum ContactListCellStyle {
    case singleNumber
    case multiNumber
}


struct ContactListCell: View {
    
    
    var contact: PhoneContact
    @State var showDetails: Bool = false
    @State var isSelected: Bool
    @State var cellStyle: ContactListCellStyle
    private let unnamed = "Unnamed"
    
    
    var body: some View {
        HStack(spacing: 16) {
            avatarImage()
            
            VStack(alignment: .leading, spacing: 2) {
                Text(contact.name)
                    .foregroundColor(.black)
                    .font(.system(size: 17, weight: .semibold))
                if cellStyle == .multiNumber {
                    Text("Выбрать номер")
                        .foregroundColor(.blue)
                        .font(.system(size: 13))
                } else {
                    Text(contact.phoneNumber.first?.key ?? "")
                        .foregroundColor(.secondary)
                        .font(.system(size: 13))
                }
                
            }
            Spacer()
            if cellStyle != .multiNumber {
                if isSelected {
                    checkmarkSquareSelect
                } else {
                    checkmarkSquare
                }
            }
        }
        .onTapGesture {
            if cellStyle != .multiNumber {
                isSelected.toggle()
                if let firstNumber = contact.phoneNumber.first?.key {
                    contact.phoneNumber[firstNumber] = isSelected
                }
            } else {
                showDetails = true
            }
        }
                .navigationDestination(isPresented: $showDetails) {
                    //ColorDetail(color: favoriteColor)
                    SingleContact(contact: contact)
                }

        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        
    }
    
    @ViewBuilder
    func avatarImage() -> some View {
        if let avatarImage = contact.avatarImage {
            Image(uiImage: avatarImage)
                .resizable()
                .frame(width: 40, height: 40)
                .aspectRatio(1, contentMode: .fit)
                .cornerRadius(20)
        } else {
            ZStack {
                defaultImage
                Text((contact.name).prefix(1))
                    .font(.system(size: 16))
                    .foregroundColor(.white)
            }
        }
    }
    
    var defaultImage: some View {
        Circle()
            .fill()
            .foregroundColor(Colors.defaultAvatarBackground)
        .frame(width: 40, height: 40)
    }
    
    var checkmarkSquare: some View {
        Image("tick-square")
            .resizable()
            .foregroundColor(.blue)
            .frame(width: 20, height: 20)
            
    }
    
    var checkmarkSquareSelect: some View {
        Image("tick-square-done")
            .resizable()
            .foregroundColor(.blue)
            .frame(width: 20, height: 20)
            
    }
}
