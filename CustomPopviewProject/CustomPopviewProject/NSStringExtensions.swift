//
//  NSStringExtensions.swift
//  NTESLocalActivities-Swift
//
//  Created by Carol on 16/5/25.
//  Copyright © 2016年 NetEase. All rights reserved.
//

import UIKit

typealias HTMLReplaceBlock = (String?)->String

extension String {
    var length: Int {
        return (self as NSString).length
    }
    
    func heightByFont(font: UIFont, width: CGFloat) -> CGFloat {
        let attributes = [NSFontAttributeName:font]
        return self.boundingRectWithSize(CGSizeMake(width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size.height
    }
    
    func sizeByFont(font: UIFont, width: CGFloat) -> CGSize {
        let attributes = [NSFontAttributeName:font]
        return self.boundingRectWithSize(CGSizeMake(width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil).size
    }
    
    func validateNetEaseEmail() -> Bool {
        let emaliRegex = "[A-Z0-9a-z._%+-]+@(vip\\.)?(126\\.com|163\\.com|netease\\.com|yeah\\.net|188\\.com)"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emaliRegex)
        return emailTest.evaluateWithObject(self)
    }
    
    //MARK: -  替换html内容
    func replaceKey(dict: [String: String?],callBack: HTMLReplaceBlock?) -> String {
        let tempString: NSMutableString = NSMutableString(string: self)
        let regulaStr = "<% .*? %>"
        do {
            let regex = try NSRegularExpression(pattern: regulaStr, options: NSRegularExpressionOptions.CaseInsensitive)
            let arrayOfAllMatchs = regex.matchesInString(self, options: NSMatchingOptions.init(rawValue: 0), range: NSMakeRange(0, (self as NSString).length))
            var substringForMatch: NSString?
            var locationOffset: Int = 0
            for match in arrayOfAllMatchs {
                let replaceRange = NSMakeRange(match.range.location + locationOffset, match.range.length)
                substringForMatch = tempString.substringWithRange(replaceRange)
                
                let key = substringForMatch?.substringWithRange(NSMakeRange(3, substringForMatch!.length - 6))
                var value: String?
                if callBack != nil {
                    value = callBack!(key)
                }
                if value == nil || (value?.isEqual(NSNull()))! {
                    if let v = dict[key!] {
                        value = v
                    }
                }
                if value == nil || (value?.isEqual(NSNull()))!{
                    value = ""
                }
                tempString.replaceCharactersInRange(replaceRange, withString: value! as String)
                locationOffset = locationOffset + ((value! as NSString).length - (substringForMatch?.length)!)
            }
            return tempString as String
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return " "
    }
}

