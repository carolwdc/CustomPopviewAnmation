# CutomPopviewAnmation
实现了几种不同动画样式的弹出框
# 使用方法

显示view

     /*显示popview的实现方法
     
     - parameter popView:           外部传入的popView，不能为nil
     - parameter viewController:      需要显示popView的controller，不能为nil
     - parameter animation:           动画效果
     - parameter backgroundClickable: 背景是否可以点击
     */
     CustomPopViewManager.sharedManager.cm_presentPopView("需要显示的view", viewController: "当前viewcontroller", 
                                                          animation:PopViewAnimationSpring(), backgroundClickable: true)

移除view动画
     /**popView消失动画
     
     - parameter animation: 动画类型
     */
     CustomPopViewManager.sharedManager.dismissPopViewWithAnimation(PopViewAnimationSpring())
  
