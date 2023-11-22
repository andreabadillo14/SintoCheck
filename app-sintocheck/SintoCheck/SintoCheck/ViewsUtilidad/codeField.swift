//
//  textField.swift
//  CodeScanningTest
//
//  Created by Sebastian on 19/11/23.
//

import SwiftUI
import Combine

extension String {
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
struct codeField: View {
    @Binding var text: String
    var field: fullCodeField.Field
    var focused: FocusState<fullCodeField.Field?>.Binding
    var textFieldDidChange: (String, fullCodeField.Field) -> Void
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(height:50)
                .foregroundColor(colorScheme == .light ? Color(red: 236/255, green: 239/255, blue: 235/255) : Color(red: 48/255, green: 48/255, blue: 48/255))
            HStack {
                TextField("A", text: $text)
                    .multilineTextAlignment(.center)
                    .focused(focused, equals: field)
                    .onChange(of: $text.wrappedValue) { oldValue, newValue in
                        textFieldDidChange(newValue, field)
                        if text.count > 1 {
                            text = String(text.prefix(1))
                        }
                    }
                   
                
//                    .frame(width:20)
//                    .background(Color.red)
                    .padding(.leading, 4)
                    .font(.system(size: 36))
                    .foregroundColor(colorScheme == .light ? Color(red: 48/255, green: 48/255, blue: 48/255) : Color(red: 236/255, green: 239/255, blue: 235/255))
//                            .background(Color.red)
            }.padding(.trailing, 3)
            
            
        }
    }
}
