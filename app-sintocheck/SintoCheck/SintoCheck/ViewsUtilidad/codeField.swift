//
//  textField.swift
//  CodeScanningTest
//
//  Created by Sebastian on 19/11/23.
//

import SwiftUI

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
                    .focused(focused, equals: field)
                    .onChange(of: $text.wrappedValue) { oldValue, newValue in
                        textFieldDidChange(newValue, field)
                    }
                    .onChange(of: $text.wrappedValue) { oldValue, newValue in
                                    if text.count > 1 {
                                        text = String(text.prefix(1))
                                    }
                                }
                
                    .frame(width:20)
                    .font(.system(size: 36))
                    .foregroundColor(colorScheme == .light ? Color(red: 48/255, green: 48/255, blue: 48/255) : Color(red: 236/255, green: 239/255, blue: 235/255))
//                            .background(Color.red)
            }.padding(.trailing, 3)
            
            
        }
    }
}
