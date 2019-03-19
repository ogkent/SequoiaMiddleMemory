//
//  CardViewController.swift
//  MtDiabloMemory
//
//  Created by Ogden Kent on 3/13/19.
//

import UIKit

class CardViewController: UIViewController {
  
  var number: Int? {
    didSet {
      if let number = number {
        backNumberLabel.text = String(number)
      } else {
        backNumberLabel.text = nil
      }
    }
  }
  
  var message: String? {
    didSet {
      frontLabel.text = message
    }
  }
  
  var tapCallback: ((CardViewController) -> ())?
  
  var isRevealed: Bool {
    get {
      return back.isHidden
    }
  }
  
  private let back: UIView
  private let front: UIView
  private let backImageView: UIImageView
  private let backNumberLabel: UILabel
  private let frontLabel: UILabel
  
  convenience init() {
    self.init(nibName:nil, bundle:nil)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    
    back = UIView(frame: CGRect.zero)
    back.backgroundColor = UIColor(patternImage: UIImage(named: "paper")!)
    
    front = UIView(frame: CGRect.zero)
    front.backgroundColor = UIColor.white
    front.isHidden = true
    
    backImageView = UIImageView(image: UIImage(named: "tree")!)
    backImageView.contentMode = .scaleAspectFit
    back.addSubview(backImageView)
    
    backNumberLabel = UILabel(frame: CGRect.zero)
    backNumberLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
    backNumberLabel.textColor = UIColor(hexString: "#333333")
    backNumberLabel.textAlignment = NSTextAlignment.center
    back.addSubview(backNumberLabel)
    
    frontLabel = UILabel(frame: CGRect.zero)
    frontLabel.font = UIFont.systemFont(ofSize: 80)
    frontLabel.textAlignment = NSTextAlignment.center
    front.addSubview(frontLabel)
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    back.layer.cornerRadius = 10;
    back.layer.masksToBounds = true;
    
    front.layer.cornerRadius = 10;
    front.layer.masksToBounds = true;
    
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.5
    view.layer.shadowRadius = 5.0
    view.layer.shadowOffset = CGSize(width: 0, height: 7)
    
    view.addSubview(back)
    view.addSubview(front)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    back.addGestureRecognizer(tapGesture)
  }
  
  override func viewDidLayoutSubviews() {
    back.frame = view.bounds
    front.frame = view.bounds
    
    backImageView.frame = back.bounds.insetBy(dx: 20, dy: 20)
    backNumberLabel.frame = CGRect(x: back.frame.size.width - 50.0, y: back.frame.size.height - 50.0, width: 50, height: 50)
    frontLabel.frame = front.bounds
  }
  
  @objc func tapped(_ sender: UIGestureRecognizer) {
    tapCallback?(self)
  }
  
  func revealFront() {
    UIView.transition(from: back, to: front, duration: 0.4, options: [.showHideTransitionViews, .transitionFlipFromRight])
  }
  
  func reset() {
    UIView.transition(from: front, to: back, duration: 0.4, options: [.showHideTransitionViews, .transitionFlipFromLeft])
  }
  
  func indicateSuccess() {
    
    let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
    pulseAnimation.beginTime = CACurrentMediaTime() + 0.8
    pulseAnimation.duration = 0.3
    pulseAnimation.toValue = NSNumber(value: 1.1)
    pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    pulseAnimation.autoreverses = true
    view.layer.add(pulseAnimation, forKey: nil)
    
    let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
    colorAnimation.beginTime = CACurrentMediaTime() + 0.8
    colorAnimation.duration = 0.3
    colorAnimation.toValue = UIColor(hexString: "#ffef8c").cgColor
    colorAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    colorAnimation.autoreverses = true
    frontLabel.layer.add(colorAnimation, forKey: nil)
    
  }
  
  func dismiss() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
  
}
