//
//  FirstGoalBadgeView.swift
//  MoneyTree
//
//  Created by Shaelyn Strong on 2024-03-21.
//

import SwiftUI

struct FirstTreeBadgeView: View {
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
                        .fill(Color.green4.opacity(0.85))
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.green4, lineWidth: 3)
                        )
                    
                    Image(systemName: "leaf")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                .padding(5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Planted a Tree")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("You planted your first tree! Keep going!")
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
    FirstTreeBadgeView()
}
