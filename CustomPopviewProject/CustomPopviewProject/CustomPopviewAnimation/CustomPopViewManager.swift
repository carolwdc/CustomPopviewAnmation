//
//  PopViewManager.swift
//  NTESLocalActivities-Swift
//
//  Created by Carol on 16/6/3.
//  Copyright © 2016年 NetEase. All rights reserved.
//

import UIKit

protocol PopViewAnimation {
    func showPopview(popView: UIView,overlayView: UIView)
    func dismissView(popView: UIView,overlayView: UIView, completion:()->())
}

class CustomPopViewManager: NSObject {
    var popView: UIView?
    var overlayView: UIView?
    var popAnimation: PopViewAnimation?
    
    private static let sharedInstance = CustomPopViewManager()
    class var sharedManager: CustomPopViewManager {
        return sharedInstance
    }
    
    /**
     显示popview的实现方法
     
     - parameter popView:           外部传入的popView，不能为nil
     - parameter viewController:      需要显示popView的controller，不能为nil
     - parameter animation:           动画效果
     - parameter backgroundClickable: 背景是否可以点击
     */
    func cm_presentPopView(popView: UIView,viewController: UIViewController, animation:PopViewAnimation?,backgroundClickable:Bool) {
        presentPopView(popView,viewController:viewController,animation:animation,backgroundClickable:backgroundClickable)
    }
    
    func dismissPopView() {
        dismissPopViewWithAnimation(self.popAnimation)
    }
    
    /**
     popView消失动画
     
     - parameter animation: 动画类型
     */
    func dismissPopViewWithAnimation(animation: PopViewAnimation?) {
        if animation != nil {
            animation!.dismissView(self.popView!, overlayView: self.overlayView!, completion: {
                self.overlayView?.removeFromSuperview()
                self.popView?.removeFromSuperview()
                self.popView = nil
                self.overlayView = nil
            })
        }else {
            self.overlayView?.removeFromSuperview()
            self.popView?.removeFromSuperview()
            self.popView = nil
            self.overlayView = nil
        }
    }
    
    /**
     显示popview的实现方法
     
     - parameter popView:           外部传入的popView，不能为nil
     - parameter viewController:      需要显示popView的controller，不能为nil
     - parameter animation:           动画效果
     - parameter backgroundClickable: 背景是否可以点击
     */
    private func presentPopView(popView: UIView,viewController: UIViewController, animation:PopViewAnimation?,backgroundClickable:Bool) {
        if let overlayView = overlayView {
            if overlayView.subviews.contains(popView) {
                return
            }
            if overlayView.subviews.count > 1 {
                dismissPopViewWithAnimation(nil)
            }
        }
        
        self.popView = popView
        self.popAnimation = animation
        
        let sourceView = topView(viewController)
        
        popView.autoresizingMask = [UIViewAutoresizing.FlexibleTopMargin,UIViewAutoresizing.FlexibleLeftMargin,UIViewAutoresizing.FlexibleBottomMargin,UIViewAutoresizing.FlexibleRightMargin]
        popView.tag = 888;
        popView.layer.shadowPath = UIBezierPath(rect: popView.bounds).CGPath;
        popView.layer.masksToBounds = false;
        popView.layer.shadowOffset = CGSizeMake(5, 5);
        popView.layer.shadowRadius = 5;
        popView.layer.shadowOpacity = 0.5;
        popView.layer.shouldRasterize = true;
        popView.layer.rasterizationScale = UIScreen.mainScreen().scale;
        
        if self.overlayView == nil {
            self.overlayView = UIView(frame: sourceView.bounds)
            overlayView!.autoresizingMask = [UIViewAutoresizing.FlexibleWidth,UIViewAutoresizing.FlexibleHeight]
            overlayView!.tag = 999
            overlayView?.backgroundColor = UIColor(white: 0.4, alpha: 0.8)
        }
        
        self.overlayView!.addSubview(popView)
        sourceView.addSubview(self.overlayView!)
        self.overlayView!.alpha = 1.0
        popView.center = self.overlayView!.center
        if animation != nil {
          animation!.showPopview(popView, overlayView: self.overlayView!)
        }
        
        if backgroundClickable {
            let tap = UITapGestureRecognizer(target: self, action: #selector(CustomPopViewManager.dismissPopView))
            overlayView?.addGestureRecognizer(tap)
        }
    }
    
    /**
     获取最底层控制器的view，用来获取overlayview的大小
     
     - parameter vc: 当前vc
     
     - returns: 获取最底层控制器的view
     */
    private func topView(vc:UIViewController)->UIView {
        var recentVC = vc
        while recentVC.parentViewController != nil {
            recentVC = recentVC.parentViewController!
        }
        return recentVC.view
    }
    
}