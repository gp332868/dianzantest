//
//  ViewController.swift
//  ppspssps
//
//  Created by guopeng on 2022/10/21.
//

import UIKit

class LiveHotCollegeGradientView: UIView {
    private let gradientLayer = CAGradientLayer()

    var colors: [UIColor] = [] {
        didSet {
            gradientLayer.colors = colors.map { $0.cgColor }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepare()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepare()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }

    func prepare() {
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0, 0.5, 1]
        layer.insertSublayer(gradientLayer, at: 0)
    }
}


class ViewController: UIViewController {

    var likeButton: UIButton!

    var flag: Bool = false

    let emitterLayer = CAEmitterLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        let btn = TestButton.init(frame: CGRect(x: 100, y: 300, width: 30, height: 30))
        view.addSubview(btn)
        self.initLikeButton()

        let blueCell = CAEmitterCell()
        blueCell.birthRate = 1 // 指定每一次发射粒子数的多少
        blueCell.lifetime = 1 // 设定粒子发射的范围
        blueCell.velocity = 50 // 粒子的速度
        blueCell.scale = 0.1 // 粒子图片的大小
        blueCell.emissionRange = CGFloat.pi * 1.0 // 粒子发射方向的范围
        blueCell.contents = UIImage(named: "1.png")!.cgImage

        let redCell = CAEmitterCell()
        redCell.birthRate = 1 // 指定每一次发射粒子数的多少
        redCell.lifetime = 1 // 设定粒子发射的范围
        redCell.velocity = 50 // 粒子的速度
        redCell.scale = 0.1  // 粒子图片的大小
        redCell.emissionRange = CGFloat.pi * 1.0 // 粒子发射方向的范围
        redCell.contents = UIImage(named: "2.png")!.cgImage

        let greenCell = CAEmitterCell()
        greenCell.birthRate = 1 // 指定每一次发射粒子数的多少
        greenCell.lifetime = 1 // 设定粒子发射的范围
        greenCell.velocity = 50 // 粒子的速度
        greenCell.scale = 0.1  // 粒子图片的大小
        greenCell.emissionRange = CGFloat.pi * 1.0 // 粒子发射方向的范围
        greenCell.contents = UIImage(named: "3.png")!.cgImage

        let yellowCell = CAEmitterCell()
        yellowCell.birthRate = 4 // 指定每一次发射粒子数的多少
        yellowCell.lifetime = 1 // 设定粒子发射的范围
        yellowCell.velocity = 50 // 粒子的速度
        yellowCell.scale = 0.1  // 粒子图片的大小
        ///yellowCell.emissionRange = CGFloat.pi * 1.0 // 粒子发射方向的范围
        yellowCell.contents = UIImage(named: "4.png")!.cgImage

        emitterLayer.emitterCells = [redCell, greenCell, yellowCell, blueCell]
        // Do any additional setup after loading the view.
    }

    func initLikeButton() {
        likeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64,  height: 64))
        likeButton.center = self.view.center
        likeButton.setImage(UIImage(named: "icon_shequ_unsupport"), for: .normal)
        likeButton.addTarget(self, action:#selector(likeButtonTapped(sender:)), for: .touchDown)
        self.view.addSubview(likeButton)
    }

}

extension ViewController {

    func playAnimation() {
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSizeMake(100, 200)
        emitterLayer.renderMode = .additive
        emitterLayer.emitterPosition = self.likeButton.center
        emitterLayer.emitterMode = .outline
    }

    @objc func likeButtonTapped(sender: UIButton) {
        flag = !flag
        if flag {
            likeButton.setImage(UIImage(named: "icon_shequ_support"), for: .normal)
            self.view.layer.addSublayer(emitterLayer)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self!.emitterLayer.removeFromSuperlayer()
            }
        } else {
            likeButton.setImage(UIImage(named: "icon_shequ_unsupport"), for: .normal)
        }
        scaleLikeButton()
        playAnimation()

    }

    func scaleLikeButton() {
        UIView.animate(withDuration: 0.2, animations: {
            let scaleTransform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.likeButton.transform = scaleTransform
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.likeButton.transform = CGAffineTransform.identity
            })
        }
    }
}

