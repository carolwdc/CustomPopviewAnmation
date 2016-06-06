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

移除view

     /* popView消失动画
     - parameter animation: 动画类型
     */
     CustomPopViewManager.sharedManager.dismissPopViewWithAnimation(PopViewAnimationSpring())

几种动画方式

     /* 
     1、PopViewAnimationSpring  由小到大，弹跳显示
     2、PopViewAnimationSlide   滑动显示动画，共有8中动画形式，
     enum PopViewAnimationSlideType: Int {
         case BottomTop     由下边出现，上边消失
         case BottomBottom  由下边出现，下边消失
         case TopTop        由上边出现，上边消失
         case TopBottom     由上边出现，下边消失 
         case LeftLeft      由左边出现，在边消失
         case LeftRight     由在边出现，右边消失
         case RightLeft     由右边出现，左边消失
         case RightRight    由右边出现，右边消失
     }
     3、PopViewAnimationFade  渐隐渐现动画
     4、PopViewAnimationDrop  带旋转的滑动动画
     */
