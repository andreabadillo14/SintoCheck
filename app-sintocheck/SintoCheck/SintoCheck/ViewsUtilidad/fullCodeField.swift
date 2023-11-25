//
//  fullCodeField.swift
//  CodeScanningTest
//
//  Created by Sebastian on 19/11/23.
//

import SwiftUI

struct fullCodeField: View {
    @State var codeCharacters : [String] = ["","","","","",""]
    @Binding var codeString : String
    
    private func textFieldDidChange(_ text: String, for field: Field) {
      if text.isEmpty {
          focusedField = Field(rawValue: field.rawValue - 1)
      } else if text.count > 0 {
          focusedField = Field(rawValue: field.rawValue + 1)
      }
    }
    enum Field: Int, CaseIterable {
        case field1, field2, field3, field4, field5, field6
    }
    
    @FocusState var focusedField: Field?
    var body: some View {
        
        HStack {
            Spacer()
            codeField(text: $codeCharacters[0], field: .field1, focused: $focusedField, textFieldDidChange: textFieldDidChange)
            codeField(text: $codeCharacters[1], field: .field2, focused: $focusedField, textFieldDidChange: textFieldDidChange)
            codeField(text: $codeCharacters[2], field: .field3, focused: $focusedField, textFieldDidChange: textFieldDidChange)
            Text("-")
            codeField(text: $codeCharacters[3], field: .field4, focused: $focusedField, textFieldDidChange: textFieldDidChange)
            codeField(text: $codeCharacters[4], field: .field5, focused: $focusedField, textFieldDidChange: textFieldDidChange)
            codeField(text: $codeCharacters[5], field: .field6, focused: $focusedField, textFieldDidChange: textFieldDidChange)
            Spacer()
        }
        .onReceive(codeCharacters.publisher.collect().map { $0.joined() }) { newValue in
            codeString = newValue
        }
    }
}

#Preview {
    fullCodeField(codeString: .constant(""))
}
