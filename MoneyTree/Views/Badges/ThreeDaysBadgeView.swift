//
//  ThreeDaysBadgeView.swift
//  MoneyTree
//
//  Created by Shaelyn Strong on 2024-03-21.
//

import SwiftUI

struct ThreeDaysBadgeView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.clear)
                .frame(maxWidth: .infinity, maxHeight: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.blue.opacity(0.8))
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.blue, lineWidth: 3)
                        )
                    
                    Image(systemName: "number")
                           .resizable()
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 40, height: 40)
                           .foregroundColor(.white)
                }
                .padding(5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Saved for 3 Days")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("You saved for three consecutive days!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .padding(5)
        }
        .cornerRadius(15)
    }
}

#Preview {
    ThreeDaysBadgeView()
}
