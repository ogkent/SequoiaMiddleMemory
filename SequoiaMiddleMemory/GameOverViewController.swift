//
//  GameOverViewController.swift
//  SequoiaMiddleMemory
//
//  Created by Ogden Kent on 3/18/19.
//  Copyright © 2019 Ogden Kent. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
  
  var tapCallback: (() -> Void)?

  var numberOfTurns: Int = 0 {
    didSet {
      countLabel.text = "You finished in \(numberOfTurns) turns."
    }
  }
  
  private let backgroundView: UIView
  private let centerView: UIView
  private let titleLabel: UILabel
  private let countLabel: UILabel
  private let emojiLabel: UILabel
  
  convenience init() {
    self.init(nibName:nil, bundle:nil)
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    
    backgroundView = UIView(frame: CGRect.zero)
    centerView = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 220))
    titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: centerView.frame.size.width, height: 70))
    countLabel = UILabel(frame: CGRect(x: 0, y: 70, width: centerView.frame.size.width, height: 50))
    emojiLabel = UILabel(frame: CGRect(x: 0, y: 120, width: centerView.frame.size.width, height: 100))
    
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  override func viewDidLoad() {
    
    backgroundView.backgroundColor = UIColor.black
    backgroundView.alpha = 0.0
    view.addSubview(backgroundView)
    
    centerView.alpha = 0.0
    view.addSubview(centerView)
    
    titleLabel.font = UIFont.systemFont(ofSize: 50, weight: .heavy)
    titleLabel.textColor = .white
    titleLabel.textAlignment = .center
    titleLabel.text = "You did it!"
    centerView.addSubview(titleLabel)
    
    countLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
    countLabel.textColor = .white
    countLabel.textAlignment = .center
    centerView.addSubview(countLabel)
    
    emojiLabel.font = UIFont.systemFont(ofSize: 80, weight: .regular)
    emojiLabel.textAlignment = .center
    emojiLabel.text = "🥳"
    centerView.addSubview(emojiLabel)
    
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
    view.addGestureRecognizer(tapGesture)
    
    super.viewDidLoad()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
    backgroundView.frame = view.bounds
    
    let frame = centerView.frame
    let y = (view.bounds.height - frame.size.height) / 2
    let x = (view.bounds.width - frame.size.width) / 2
    centerView.frame = CGRect(origin: CGPoint(x: x, y: y), size: frame.size)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseIn, animations: {
      self.backgroundView.alpha = 0.7
    }) { (completed) in
      UIView.animate(withDuration: 0.5, delay: 1, options: .curveEaseIn, animations: {
        self.centerView.alpha = 1.0
      })
    }
  }
  
  @objc func tapped(_ sender: UIGestureRecognizer) {
    UIView.animate(withDuration: 0.5, animations: {
      self.view.alpha = 0.0
    }) { (completed) in
      self.tapCallback?()
      self.dismiss()
    }
  }
  
  func dismiss() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
  
}
