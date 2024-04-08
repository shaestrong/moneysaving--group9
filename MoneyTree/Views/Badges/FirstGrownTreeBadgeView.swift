//
//  FirstGrownTreeBadge.swift
//  MoneyTree
//
//  Created by Shaelyn Strong on 2024-03-24.
//

import SwiftUI

struct FirstGrownTreeBadgeView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.clear)
                .frame(maxWidth: .infinity, maxHeight: 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray, lineWidth: 1)
                )
            
            HStack() {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.yellow.opacity(0.8))
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.yellow, lineWidth: 3)
                        )
                    
                    Image(systemName: "tree")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                }
                .padding(5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Grew a Tree")
                        .font(.headline)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("You grew your first tree! Great job!")
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
    FirstGrownTreeBadgeView()
}
