//
//  testModel.swift
//  PixaBayProject
//
//  Created by Phoenix McKnight on 5/18/20.
//  Copyright © 2020 Phoenix McKnight. All rights reserved.
//

import Foundation

class TestModel {
 static var testNumber:Int? = nil
static var testString:String? = nil
    
    
    func changeTestNumber() {
        if TestModel.testNumber == nil  {
            TestModel.testNumber = 0
        }
        
        if TestModel.testString == nil {
            TestModel.testString = ""
        }
        
        TestModel.testNumber! += 10
        TestModel.testString! += "the current number is \(TestModel.testNumber ?? 0)"
    }
    
    
}
