//
//  NTESAlertView.swift
//  NTESLocalActivities-Swift
//
//  Created by Carol on 16/5/25.
//  Copyright © 2016年 NetEase. All rights reserved.
//

import UIKit

let ALERTVIEW_WIDTH: CGFloat = 260
let CONTENTVIEW_WIDTH: CGFloat = ALERTVIEW_WIDTH - 40

let ButtonHeigh: CGFloat = 35
let TextFont: UIFont = UIFont.boldSystemFontOfSize(15)

protocol NETSAlertViewDelegate {
    func alertViewCancelButtonAction(alertView: NTESAlertView)
    func alertViewOkButtonAction(alertView: NTESAlertView)
}

class NTESAlertView: UIView {
    
    var backgroundClickable: Bool = true
    var contentView: UIView!
    
    var delegate: NETSAlertViewDelegate?
    
    //private
    private var title: String?
    private var parentVC: UIViewController?
    private var cancleButton: UIButton?
    private var okButton: UIButton?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.redColor()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(12)
        label.textAlignment = NSTextAlignment.Center
        self.addSubview(label)
        return label
    }()
    
    convenience init(title: String?,message: String,delegate: NETSAlertViewDelegate?,cancelButtonTitle: String?,okButtonTitle: String?) {
        let textHeight: CGFloat = message.heightByFont(TextFont, width: ALERTVIEW_WIDTH - 40)
        let messageLabel = UILabel(frame: CGRectMake(0,0,CONTENTVIEW_WIDTH,textHeight))
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.font = TextFont
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.numberOfLines = -1
        messageLabel.text = message
        
        self.init(title:title,contentView: messageLabel,delegate: delegate,cancleButtonTitle: cancelButtonTitle,okButtonTitle: okButtonTitle)
    }
    
    init(title: String?, contentView: UIView,delegate: NETSAlertViewDelegate?,cancleButtonTitle: String?,okButtonTitle: String?) {
        super.init(frame: CGRectZero)
        self.title = title
        self.delegate = delegate
        self.backgroundClickable = true
        
        self.backgroundColor = UIColor.whiteColor()
        
        self.titleLabel.text = title
        
        self.contentView = contentView
        self.addSubview(contentView)
        
        if cancleButtonTitle != nil {
            let button = UIButton()
            button.addTarget(self, action: #selector(NTESAlertView.cancleAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor.grayColor()
            button.titleLabel?.font = UIFont.systemFontOfSize(12)
            self.addSubview(button)
            button.setTitle(cancleButtonTitle!, forState: UIControlState.Normal)
            self.cancleButton = button
        }
        
        if okButtonTitle != nil {
            let button = UIButton()
            button.addTarget(self, action: #selector(NTESAlertView.okAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            button.layer.cornerRadius = 5
            button.backgroundColor = UIColor.redColor()
            button.titleLabel?.font = UIFont.systemFontOfSize(12)
            button.setTitle(okButtonTitle, forState: UIControlState.Normal)
            self.addSubview(button)
            self.okButton = button
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let alertWidth = ALERTVIEW_WIDTH
        var yOffset: CGFloat = 0
        titleLabel.frame = CGRectMake(0, 0, alertWidth, ((title != nil) ? 35 : 4))
        yOffset = titleLabel.bounds.size.height
        contentView.frame = CGRectMake(20, yOffset + 25, CONTENTVIEW_WIDTH, contentView.bounds.size.height)
        
        yOffset = yOffset + 25 + contentView.bounds.size.height
        
        if cancleButton != nil && (okButton != nil) {
            cancleButton?.frame = CGRectMake(20, yOffset + 30, 100, ButtonHeigh)
            okButton?.frame = CGRectMake(alertWidth - 20 - 100, yOffset + 30, 100, ButtonHeigh)
            yOffset = yOffset + 30 + ButtonHeigh
        }else if (cancleButton != nil){
            cancleButton?.frame = CGRectMake((alertWidth-160)/2, yOffset+30, 160, ButtonHeigh);
            yOffset = yOffset+30+ButtonHeigh;
        }else if (okButton != nil){
            okButton?.frame = CGRectMake((alertWidth-160)/2, yOffset+30, 160, ButtonHeigh);
            yOffset = yOffset+30+ButtonHeigh;
        }
        self.bounds = CGRectMake(0, 0, alertWidth, yOffset + 25)
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
    }
    
    //MARK: - CUSTOM METHOD
    
    func showInViewController(vc: UIViewController) {
        parentVC = vc
        CustomPopViewManager.sharedManager.cm_presentPopView(self, viewController: vc, animation: PopViewAnimationSpring(), backgroundClickable: true)
    }
    
    func dismiss() {
        CustomPopViewManager.sharedManager.dismissPopView()
    }
    
    func cancleAction(sender: UIButton)  {
        if delegate != nil {
            delegate?.alertViewCancelButtonAction(self)
        }
        dismiss()
    }
    
    func okAction(sender: UIButton) {
        if delegate != nil {
            delegate?.alertViewOkButtonAction(self)
        }
    }
}
