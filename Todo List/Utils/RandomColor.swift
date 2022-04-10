//
//  RandomColor.swift
//  Todo List
//
//  Created by Javier Cueto on 10/04/22.
//

import UIKit

struct RandomColor {
    private let colors: [UIColor] = [.red,.blue,.brown,.magenta,.orange,.purple,.systemBlue]
    private var currentColor: UIColor = UIColor()
    
    public var color: UIColor {
        return currentColor
    }
    
    init() {
        currentColor = colorRandom()
    }
    
    private func colorRandom() -> UIColor{
        let index = Int.random(in: 0..<colors.count)
        return colors[index]
    }
}
