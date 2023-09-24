//
//  ContentView.swift
//  Hello Calculator
//
//  Created by Micah Aldrich on 9/17/23.
//

import SwiftUI

let helloKittyPink = UIColor(red: 1.00, green: 0.71, blue: 0.76, alpha: 1.0)

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "/"
    case multiply = "x"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return Color(.white)
        case .clear, .negative, .percent:
            return Color(.white)
        default:
            return Color(.white)
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
    
    init?(rawValue: String) {
        switch rawValue {
        case "+":
            self = .add
        case "-":
            self = .subtract
        case "x":
            self = .multiply
        case "/":
            self = .divide
        default:
            self = .none
        }
    }
}

struct ContentView: View {
    @State var value = "0"
    @State var runningNumber = 0.0
    @State var currentOperation: Operation = .none

    let maxDigitsToShow = 10 // Adjust this value as needed

    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]

    var body: some View {
        // Black background
        ZStack {
            Color(helloKittyPink).edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()
                // Text display
                HStack {
                    Text(value)
                        .bold()
                        .font(.system(size: calculateFontSize()))
                        .foregroundColor(.black)
                        .lineLimit(1) // Ensures text doesn't go to the next line
                        .minimumScaleFactor(0.5) // Allows text to scale down if needed
                        .frame(maxWidth: .infinity, alignment: .trailing) // Right-align text
                }
                .padding()

                // Buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(item: item), height: self.buttonHeight())
                                    .background(item.buttonColor)
                                    .foregroundColor(.black)
                                    .cornerRadius(self.buttonWidth(item: item) / 2)
                            })
                        }
                    }
                }
            }
        }
    }

    func calculateFontSize() -> CGFloat {
        let digitCount = value.count
        if digitCount <= 5 {
            return 100.0 // Default font size
        } else {
            let scaleFactor = CGFloat(maxDigitsToShow) / CGFloat(digitCount)
            return 100.0 * scaleFactor
        }
    }
    
    func didTap(button: CalcButton) {
        switch button {

        case .percent:
            let doubleValue = Double(value) ?? 0
            let percent = doubleValue / 100
            value = "\(percent)"

        case .negative:
            if value.hasPrefix("-") {
                value.removeFirst()
            } else {
                value = "-\(value)"
            }

        case .decimal:
            if !value.contains(".") {
                value += "."
            }

        case .equal:
            let currentValue = Double(self.value) ?? 0.0

            switch self.currentOperation {
            case .add:
                runningNumber += currentValue

            case .subtract:
                runningNumber -= currentValue

            case .multiply:
                runningNumber *= currentValue

            case .divide:
                runningNumber /= currentValue

            case .none:
                break
            }

            value = "\(runningNumber)"
            currentOperation = .none

        case .clear:
            self.value = "0"
            runningNumber = 0.0
            currentOperation = .none

        case .add, .subtract, .multiply, .divide:
            if currentOperation != .none {
                let currentValue = Double(self.value) ?? 0.0

                switch currentOperation {
                case .add:
                    runningNumber += currentValue

                case .subtract:
                    runningNumber -= currentValue

                case .multiply:
                    runningNumber *= currentValue

                case .divide:
                    runningNumber /= currentValue

                case .none:
                    break
                }

                value = "\(runningNumber)"
            }

            if button != .equal {
                runningNumber = Double(self.value) ?? 0.0
                currentOperation = Operation(rawValue: button.rawValue) ?? .none
                value = "0"
            }

        default:
            if value == "0" || currentOperation != .none {
                value = button.rawValue
            } else if value == "-0" {
                value = "-\(button.rawValue)"
            } else {
                self.value = "\(self.value)\(button.rawValue)"
            }
        }
    }

    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4 * 12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
