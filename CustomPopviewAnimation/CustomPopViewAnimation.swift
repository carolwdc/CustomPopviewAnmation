//
//  PopViewAnimationDrop.swift
//  NTESLocalActivities-Swift
//
//  Created by Carol on 16/6/3.
//  Copyright © 2016年 NetEase. All rights reserved.
//

import UIKit

enum PopViewAnimationSlideType: Int {
    case BottomTop
    case BottomBottom
    case TopTop
    case TopBottom
    case LeftLeft
    case LeftRight
    case RightLeft
    case RightRight
}

class PopViewAnimationDrop: NSObject,PopViewAnimation {
    func showPopview(popView: UIView,overlayView: UIView) {
        popView.center = CGPointMake(overlayView.center.x, -popView.bounds.size.height / 2)
        popView.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI)/2)
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            popView.transform = CGAffineTransformMakeRotation(0)
            popView.center = overlayView.center
            }, completion: nil)
    }
    
    func dismissView(popView: UIView,overlayView: UIView, completion:()->()) {
        UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            popView.center = CGPointMake(overlayView.center.x, overlayView.bounds.size.height + popView.bounds.size.height)
            popView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI / 1.5))
        }) { (finished) in
            completion()
        }
    }
}

class PopViewAnimationFade: NSObject,PopViewAnimation {
    func showPopview(popView: UIView,overlayView: UIView) {
        popView.center = overlayView.center;
        popView.alpha = 0.0
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            popView.alpha = 1.0
            }, completion: nil)
    }
    
    func dismissView(popView: UIView,overlayView: UIView, completion:()->()) {
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            overlayView.alpha = 0.0
            popView.alpha = 0.0
        }) { (finished) in
            completion()
        }
    }
}

class PopViewAnimationSpring: NSObject,PopViewAnimation {
    var _completion: (()->())?
    
    func showPopview(popView: UIView,overlayView: UIView) {
        popView.alpha = 1.0
        let popAnimation = CAKeyframeAnimation(keyPath: "transform")
        popAnimation.duration = 0.4;
        popAnimation.values = [NSValue(CATransform3D: CATransform3DMakeScale(0.01, 0.01, 1.0)),NSValue(CATransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),NSValue(CATransform3D: CATransform3DMakeScale(0.9, 0.9, 1.0)),NSValue(CATransform3D: CATransform3DIdentity)];
        popAnimation.keyTimes = [0.2, 0.5, 0.75, 1.0];
        popAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
        CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
        CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        popView.layer.addAnimation(popAnimation, forKey: nil)
    }
    
    func dismissView(popView: UIView,overlayView: UIView, completion:()->()) {
        _completion = completion
        UIView.animateWithDuration(0.4) { 
            overlayView.alpha = 0.0
        }
        let hideAnimation = CAKeyframeAnimation(keyPath: "transform")
        hideAnimation.duration = 0.4;
        hideAnimation.values = [NSValue(CATransform3D: CATransform3DMakeScale(1.1, 1.1, 1.0)),NSValue(CATransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)),NSValue(CATransform3D: CATransform3DMakeScale(0.0, 0.0, 0.0))];
        hideAnimation.keyTimes = [0.2, 0.5, 0.75];
        hideAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                                        CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
                                        CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        hideAnimation.delegate = self
        popView.layer.addAnimation(hideAnimation, forKey: nil)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        _completion!()
    }
}

class PopViewAnimationSlide: NSObject,PopViewAnimation {
    var type: PopViewAnimationSlideType = .BottomTop
    
    init(type: PopViewAnimationSlideType) {
        self.type = type
        super.init()
    }
    
    func showPopview(popView: UIView,overlayView: UIView) {
        let sourceSize = overlayView.bounds.size
        let popSize = popView.bounds.size
        var popStartRect = CGRectZero
        switch type {
        case .BottomTop,.BottomBottom:
            popStartRect = CGRectMake((sourceSize.width - popSize.width)/2, sourceSize.height, popSize.width, popSize.height)
            break
        case .LeftLeft,.LeftRight:
            popStartRect = CGRectMake(-sourceSize.width, (sourceSize.height - popSize.height)/2, popSize.width, popSize.height)
            break
        case .TopTop,.TopBottom:
            popStartRect = CGRectMake((sourceSize.width - popSize.width)/2, -sourceSize.height, popSize.width, popSize.height)
            break
        case .RightLeft,.RightRight:
            popStartRect = CGRectMake(sourceSize.width, (sourceSize.height - popSize.height)/2, popSize.width, popSize.height)
            break
        }
        
        let popReact = CGRectMake((sourceSize.width - popSize.width)/2, (sourceSize.height - popSize.height)/2, popSize.width, popSize.height)
        popView.frame = popStartRect
        popView.alpha = 1.0
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { 
            popView.frame = popReact
            }, completion: nil)
    }
    
    func dismissView(popView: UIView,overlayView: UIView, completion:()->()) {
        let sourceSize = overlayView.bounds.size
        let popSize = popView.bounds.size
        var popEndRect = CGRectZero
        switch type {
        case .BottomTop,.BottomBottom:
            popEndRect = CGRectMake((sourceSize.width - popSize.width)/2, sourceSize.height, popSize.width, popSize.height)
            break
        case .LeftLeft,.LeftRight:
            popEndRect = CGRectMake(-sourceSize.width, (sourceSize.height - popSize.height)/2, popSize.width, popSize.height)
            break
        case .TopTop,.TopBottom:
            popEndRect = CGRectMake((sourceSize.width - popSize.width)/2, -sourceSize.height, popSize.width, popSize.height)
            break
        case .RightLeft,.RightRight:
            popEndRect = CGRectMake(sourceSize.width, (sourceSize.height - popSize.height)/2, popSize.width, popSize.height)
            break
        }

        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            popView.frame = popEndRect
            overlayView.alpha = 0.0
        }){ (finished) in
            completion()
        }
    }
}

