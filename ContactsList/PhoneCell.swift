//
//  PhoneCell.swift
//  ContactsList
//
//  Created by Ангелина Решетникова on 09.10.2023.
//

import Foundation

import Foundation
import SwiftUI
import Contacts



struct PhoneCell: View {
    
    
    var contact: PhoneContact
    var phone: String
    @State var isSelected: Bool
    let unnamed = "Unnamed"
    
    
    var body: some View {
            HStack(spacing: 16) {
                
                VStack(alignment: .leading, spacing: 2) {

                    Text("телефон")
                        .foregroundColor(.black)
                        .font(.system(size: 17, weight: .semibold))
                    Text(phone)
                        .foregroundColor(.blue)
                    
                }
                Spacer()
                    if isSelected {
                        checkmarkSquareSelect
                    } else {
                        checkmarkSquare
                    }
            }
            .onTapGesture {
                isSelected.toggle()
                contact.phoneNumber[phone] = isSelected
            
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
                Text(contact.name.prefix(1))
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
