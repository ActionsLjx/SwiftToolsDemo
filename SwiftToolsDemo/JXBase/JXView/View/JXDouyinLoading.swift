//
//  JXDouyinLoading.swift
//  Goallive
//
//  Created by ken Z on 2024/1/11.
//

import UIKit

enum BallMoveDirection:Int{

    case BallMoveDirectionPositive = 1 //正向
    case BallMoveDirectionNegative = -1 //逆向

}

extension JXDouyinLoading{
    static func showInView(view:UIView) -> JXDouyinLoading{
        let loading = JXDouyinLoading.init(frame: view.bounds)
        view.addSubview(loading)
        loading.startAnimated()
        return loading
    }
    
    static func hideInView(view:UIView){
        for v in view.subviews{
            if(v.isKind(of: JXDouyinLoading.self)){
                v.removeFromSuperview()
            }
        }
    }
}

class JXDouyinLoading: UIView {
    //球宽
    var BallWidth:CGFloat = 12.0;

    //球速
    var BallSpeed:CGFloat = 0.7;

    //球缩放比例
    var BallZoomScale:CGFloat = 0.25;

    //暂停时间 s
    var PauseSecond:CGFloat = 0.18;
  
    //球的颜色
    var leftBallColor:UIColor = UIColor.init(r: 250, g: 222, b: 186, alpha: 1)
    var rightBallColor:UIColor = UIColor.init(r: 233, g: 186, b: 117, alpha: 1)
    //球的容器
    private var ballContainer:UIView!
    //绿球
    private var greenBall:UIView!
    //红球
    private var redBall:UIView!
    //黑球
    private var blackBall:UIView!
    //移动方向
    private var ballMoveDirection:BallMoveDirection = .BallMoveDirectionPositive
    //刷新器
    private var displayLink:CADisplayLink!
    private var isJustChange:Bool = false
    private var isAnimation:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialFromXib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialFromXib()
    }
    
    private func initialFromXib() {
        self.ballContainer = UIView.init(frame: CGRect(x: 0, y: 0, width: 2.1*BallWidth, height: 2*BallWidth))
        self.ballContainer.center = self.center
        self.addSubview(self.ballContainer)
        
        self.greenBall = UIView(frame: CGRect(x: 0, y: 0, width: BallWidth, height: BallWidth))
        self.greenBall.center = CGPoint(x: BallWidth/2, y: self.ballContainer.bounds.size.height/2)
        self.greenBall.layer.cornerRadius = BallWidth/2
        self.greenBall.layer.masksToBounds = true
        self.greenBall.backgroundColor = leftBallColor
        self.ballContainer.addSubview(self.greenBall)

        self.redBall = UIView(frame: CGRect(x: 0, y: 0, width: BallWidth, height: BallWidth))
        self.redBall.center = CGPoint(x: self.ballContainer.size.width - BallWidth/2, y: self.ballContainer.bounds.size.height/2)
        self.redBall.layer.cornerRadius = BallWidth/2
        self.redBall.backgroundColor = rightBallColor
        self.ballContainer.addSubview(self.redBall)
//
//        //第一次动画是正向，绿球在上，红球在下，阴影会显示在绿球上
        self.blackBall = UIView(frame: CGRect(x: 0, y: 0, width: BallWidth, height: BallWidth))
        self.blackBall.backgroundColor = UIColor.init(r: 12, g: 11, b: 17, alpha: 1)
        self.blackBall.layer.cornerRadius = BallWidth/2
        self.blackBall.layer.masksToBounds = true
//        self.greenBall.addSubview(self.blackBall)
//
//        //初始化方向是正向
        self.ballMoveDirection = .BallMoveDirectionPositive;
//        //初始化刷新方法
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(updateBallAnimations))
    }
    
    func startAnimated(){
        if(!self.isAnimation){
            self.isAnimation = true
            self.displayLink .add(to: RunLoop.main, forMode: .common)
        }
    }
    
    func stopAnimated(){
        if(self.isAnimation){
            self.isAnimation = false
            self.displayLink.remove(from: RunLoop.main, forMode: .common)
        }
    }
    
    func pauseAnimated(){
        self.stopAnimated()
        let delayTime = DispatchTime.now() + Double(PauseSecond)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            // 在主队列中执行的代码块，即延迟后要执行的代码
            self.startAnimated()
        }
    }
    
    
    @objc func updateBallAnimations() {
        if ballMoveDirection == .BallMoveDirectionPositive { // 正向运动
            // 更新绿球位置
            var center = greenBall.center
            center.x += BallSpeed
            greenBall.center = center

            // 更新红球位置
            center = redBall.center
            center.x -= BallSpeed
            redBall.center = center

            // 缩放动画，绿球放大，红球变小
            greenBall.transform = ballLargerTransform(ofCenterX: center.x)
            redBall.transform = ballSmallerTransform(ofCenterX: center.x)

            // 更新黑球位置
//            let blackBallFrame = redBall.convert(redBall.bounds, to: greenBall)
//            blackBall.frame = blackBallFrame
//            blackBall.layer.cornerRadius = blackBall.bounds.size.width / 2.0
//            if(isJustChange){
//                greenBall.addSubview(blackBall)
//                isJustChange = false
//            }
            // 更新方向 + 改变三个球的相对位置
            if greenBall.frame.maxX >= ballContainer.bounds.size.width || redBall.frame.minX <= 0 {
                // 切换为反向
                ballMoveDirection = .BallMoveDirectionNegative
                // 反向运动时，红球在上，绿球在下
                ballContainer.bringSubviewToFront(redBall)
                // 黑球放在红球上面
                self.isJustChange = true
                // 暂停一下
                pauseAnimated()
            }
        } else if ballMoveDirection == .BallMoveDirectionNegative { // 反向运动
            // 更新绿球位置
            var center = greenBall.center
            center.x -= BallSpeed
            greenBall.center = center

            // 更新红球位置
            center = redBall.center
            center.x += BallSpeed
            redBall.center = center

            // 缩放动画，红球放大，绿/黑球变小
            redBall.transform = ballLargerTransform(ofCenterX: center.x)
            greenBall.transform = ballSmallerTransform(ofCenterX: center.x)

            // 更新黑球位置
//            let blackBallFrame = greenBall.convert(greenBall.bounds, to: redBall)
//            blackBall.frame = blackBallFrame
//            blackBall.layer.cornerRadius = blackBall.bounds.size.width / 2.0
//            if(isJustChange){
//                redBall.addSubview(blackBall)
//                isJustChange = false
//            }
            // 更新方向 + 改变三个球的相对位置
            if greenBall.frame.minX <= 0 || redBall.frame.maxX >= ballContainer.bounds.size.width {
                // 切换为正向
                ballMoveDirection = .BallMoveDirectionPositive
                // 正向运动时，绿球在上，红球在下
                ballContainer.bringSubviewToFront(greenBall)
                // 黑球放在绿球上面
                self.isJustChange = true
                // 暂停动画
                pauseAnimated()
            }
        }
    }
    // 放大动画
    func ballLargerTransform(ofCenterX centerX: CGFloat) -> CGAffineTransform {
        let cosValue = cosValue(ofCenterX: centerX)
        return CGAffineTransform(scaleX: 1 + cosValue * BallZoomScale, y: 1 + cosValue * BallZoomScale)
    }

    // 缩小动画
    func ballSmallerTransform(ofCenterX centerX: CGFloat) -> CGAffineTransform {
        let cosValue = cosValue(ofCenterX: centerX)
        return CGAffineTransform(scaleX: 1 - cosValue * BallZoomScale, y: 1 - cosValue * BallZoomScale)
    }

    
    // 根据余弦函数获取变化区间，变化范围是 0~1~0
    func cosValue(ofCenterX centerX: CGFloat) -> CGFloat {
        let apart = centerX - ballContainer.bounds.size.width / 2.0
        // 最大距离(球心距离Container中心距离)
        let maxApart = (ballContainer.bounds.size.width - BallWidth) / 2.0
        // 移动距离和最大距离的比例
        let angle = apart / maxApart * CGFloat.pi / 2.0
        // 获取比例对应余弦曲线的Y值
        return cos(angle)
    }

}
