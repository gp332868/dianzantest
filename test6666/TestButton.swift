//
//  TestButton.swift
//  ppspssps
//
//  Created by guopeng on 2022/10/24.
//

import UIKit
import AudioToolbox.AudioServices

enum AnimationStyle {
    case tapstyle
    case longstyle
}

class TestButton: UIButton {
    private var streamerLayer = CAEmitterLayer()

    private var imageArr: [String] = []

    private var cellArr: [CAEmitterCell] = []

    private let zanLabel: UILabel = UILabel.init()

    private var timer: DispatchSourceTimer?

    private var zancount: Int = 1

    private var firstTouchFlag: Bool = false
    private var lastTouchTime: Int = 0

    private var feedbackGenerator : UIImpactFeedbackGenerator? = UIImpactFeedbackGenerator(style: .light)

    override init(frame: CGRect) {
        super.init(frame: frame)
        getlayer()
        setup()
    }

    func getlayer() {

        streamerLayer.removeFromSuperlayer()
        streamerLayer = CAEmitterLayer()
        streamerLayer.emitterSize   = CGSizeMake(1, 1)
        streamerLayer.emitterShape = .point
        /// 发射模式，它的作用其实就是进一步决定发射的区域是在发射形状的哪一部份，rPoints 点模式，发射器是以点的形式发射粒子。发射点就是形状的某个特殊的点，比如shap是一个点的话，那么这个点就是中心点，如果是圆形，那么就是圆心。Outline 轮廓模式，从形状的边界上发射粒子，Surface 表面模式，从形状的表面上发射粒子，Volume 是相对于3D形状的物体内部发射
        streamerLayer.emitterMode = .points
        /// 渲染模式，决定了粒子是以怎么一种形式进行渲染的，Unordered 粒子是无序出现的， OldestFirst 声明时间长的粒子会被渲染在最上层，OldestLast 声明时间短的粒子会被渲染在最上层，BackToFront 粒子的渲染按照Z轴的前后顺序进行，Additive 进行粒子混合
        streamerLayer.renderMode = .additive
        /// 决定发射源的中心点

        layer.addSublayer(streamerLayer)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        streamerLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
    }

    deinit {
        feedbackGenerator = nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let noeDate = NSDate()
        let touchend = Int(noeDate.timeIntervalSince1970)
        if !firstTouchFlag {
            lastTouchTime = touchend
            firstTouchFlag = true
        } else {
            if noeDate - lastTouchTime > 1 {
               /// 不显示 点赞数目动画
            } else {
              /// 显示点赞数目动画
            }

        }


//        timer = DispatchSource.makeTimerSource()
//        timer?.schedule(deadline: .now(), repeating: .seconds(1))
//        timer?.setEventHandler {
//            DispatchQueue.main.async {
//                self.touchSeconds += 1
//                self.changeText()
//            }
//        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let noeDate = NSDate()
        let touchend = Int(noeDate.timeIntervalSince1970)



    }




}

extension TestButton {
    func setup() {
        zanLabel.frame = CGRect(x: 0, y: -80, width: 130, height: 50)
        zanLabel.backgroundColor = .orange
        zanLabel.isHidden = true
        addSubview(zanLabel)
        setImage(UIImage.init(named: "icon_shequ_unsupport"), for: .normal)
        setImage(UIImage.init(named: "icon_shequ_support"), for: .selected)
        ///addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(pressOnece)))
        addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(longPress)))
    }


    @objc func pressOnece(tap: UITapGestureRecognizer) {
        let btn: UIButton = tap.view as! UIButton
        btn.isSelected = !btn.isSelected
        if !isSelected {
            zancount = 0
            ///explode()
        } else {
            self.getlayer()
            animation(style: .tapstyle)

            let time: TimeInterval = 0.1
            let delay = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: delay) { [weak self] in
                self?.explode()
            }
        }
    }

    @objc func longPress(longPress: UILongPressGestureRecognizer) {
        let btn: UIButton = longPress.view as! UIButton
        btn.isSelected = true
        if (longPress.state == .began) {
            self.getlayer()
            self.animation(style: .longstyle)
        }else if (longPress.state == .ended)
        {
            self.explode()
        }
    }

    func animation(style: AnimationStyle) {
        if style == .longstyle {
            showAnimationWithBirthRate(rate: 5)
            zanLabel.isHidden = false
            timer = DispatchSource.makeTimerSource()
            timer?.schedule(deadline: .now(), repeating: .milliseconds(100))
            timer?.setEventHandler {
                DispatchQueue.main.async {
                    self.changeText()
                }
            }
            timer?.resume()
        } else {
            showAnimationWithBirthRate(rate: 1)
        }
    }

    func changeText() {
        zancount += 1
        if let style = getAttributedString() {
            zanLabel.attributedText = style
        }
        feedbackGenerator?.impactOccurred()
        zanLabel.textAlignment = .center
    }

    // 开始动画
    func showAnimationWithBirthRate(rate: Float) {
        imageArr.removeAll()
        cellArr.removeAll()
            (0..<5).forEach {index  in
                let str = "smiley_" + "\(Int.random(in: 0..<12))"
                imageArr.append(str)
            }
            cellArr = imageArr.map { str in
                let cell = getEmitterCell(image: UIImage.init(named: str)!, name: str)
                return cell
            }
        streamerLayer.emitterCells = cellArr
        streamerLayer.setValue(rate, forKey: "birthRate")
    }

    // 停止动画
    @objc func explode() {
        streamerLayer.setValue(0, forKey: "birthRate")
        zanLabel.isHidden = true
        zancount = 0
        timer?.cancel()
        timer = nil
        (0..<cellArr.count).forEach { index in
            let cell: CAEmitterCell = cellArr[index]
            cell.lifetime = 0
            cell.birthRate = 0
            cell.lifetimeRange = 0
            cell.scale = 0
        }
        print("ososossos")
        print(cellArr)

    }

    func getAttributedString() -> (NSAttributedString?) {

        if (zancount >= 1000) {
            return nil
        } else {
            let mutstr = NSMutableAttributedString.init(string: "\(zancount)", attributes: [
                NSAttributedString.Key.font: UIFont(name: "Arial-BoldItalicMT", size: 30)!,
                NSAttributedString.Key.foregroundColor: UIColor.init(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            ])
            /// 先把zancount 拆成个十百
             ///let ge = zancount % 10
             let shi = zancount % 100 / 10
             let bai = zancount % 1000 / 100
            if bai != 0 {
                let attachment = NSTextAttachment()
                let image = UIImage.init(named: "taibangle")
                attachment.image = image
                attachment.bounds = CGRect(
                    x: 0,
                    y: -3,
                    width: 74,
                    height: 36
                )
                let str = NSAttributedString.init(attachment: attachment)
                mutstr.append(str)
            } else if shi != 0 && bai == 0 {
                let attachment = NSTextAttachment()
                attachment.image = UIImage.init(named: "jiayou")
                attachment.bounds = CGRect(
                    x: 0,
                    y: -3,
                    width: 58,
                    height: 36
                )
                let str = NSAttributedString.init(attachment: attachment)
                mutstr.append(str)
            } else {
                let attachment = NSTextAttachment()
                attachment.image = UIImage.init(named: "guli")
                let str = NSAttributedString.init(attachment: attachment)
                attachment.bounds = CGRect(
                    x: 0,
                    y: -3,
                    width: 89,
                    height: 37
                )
                mutstr.append(str)
            }
            return mutstr
        }
    }

    func getEmitterCell(image: UIImage, name: String) -> (CAEmitterCell) {
        let smoke = CAEmitterCell()
        smoke.birthRate = 1 ///每秒出现多少个粒子
        smoke.lifetime = 1 /// 粒子的存活时间1秒
        smoke.lifetimeRange = 1
        smoke.scale = 0.35 /// 粒子缩放比例

        smoke.alphaRange = 1
        smoke.alphaSpeed = 0 ///消失范围
        smoke.yAcceleration = 400///大于0有下落的效果
        let image2: CGImage = image.cgImage!
        smoke.contents = image2
        smoke.name = name //设置这个 用来展示喷射动画 和隐藏

        smoke.velocity = 500 ///速度
        smoke.velocityRange = 200 /// 平均速度
        smoke.emissionLongitude = CGFloat.pi*3/2
        smoke.emissionRange = CGFloat.pi/2 //
        ////粒子的发散范围
       /// smoke.spin = CGFloat.pi  /// 粒子的平均旋转速度
        ///smoke.spinRange = CGFloat.pi * 2 /// 粒子的旋转速度调整范围
        return smoke
    }
}
