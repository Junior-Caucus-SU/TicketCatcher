//
//  RemoveSheetView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 5/15/24.
//

import SwiftUI

struct RemoveSheetView: View {
    @State private var isRemoving: Bool = false
    
    let correctPassword = Secrets.adminPassword
    let correctName = Secrets.adminName
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0){
                VStack (alignment: .leading){
                    Text("This will remove all records up until the single operation limit. If you wish to remove all records, you may have to try multiple times. This is not reversible.")
                        .bold()
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .padding(.bottom)
                    
                    Text("Removing records may take up to 1 minute. The app will quit upon completion. Call 929-519-5260 for confirmation before proceeding.")
                        .foregroundColor(.red)
                        .font(.caption)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.leading)
                }.padding([.top, .leading, .trailing])
                Spacer()
                Button(role: .destructive, action: {
                    isRemoving = true
                    CKManager.shared.removeAllCodenames() { error in
                        if error != nil {
                            LogManager.shared.log("Could not remove all records.")
                        } else {
                            LogManager.shared.log("Removed all records.")
                        }
                        isRemoving = false
                        exit(0)
                    }
                }, label: {
                    HStack {
                        Text(isRemoving ? "Removing Records..." : "Remove Attendees")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if (isRemoving) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(0.5)
                                .frame(width: 20, height: 20)
                        } else {
                            Image(systemName: "trash")
                        }
                    }
                })
                .buttonStyle(.borderedProminent)
                .cornerRadius(20)
                .padding()
                .controlSize(.large)
                .disabled(isRemoving)
            }
            .navigationTitle("Remove Attendees")
        }
    }
}

#Preview {
    RemoveSheetView()
}
