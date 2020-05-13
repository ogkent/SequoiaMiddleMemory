//
//  ViewController.swift
//  SequoiaMiddleMemory
//
//  Created by Ogden Kent on 3/13/19.
//

import UIKit

class ViewController: UIViewController {
  
  
  
  let rows = 3
  let cols = 6
  let spacing = Float(30)
  
  private let messages:[String] = [
    "🌭", "👻", "🙅🏾‍♀️", "🧤", "🎺", "🏔", "🕹", "🛸", "🎯",
    "🧯", "🧟‍♂️", "🕺🏻", "🧵", "🐝", "🐲", "🥥", "🌯", "🏓",
    "🎨", "🚜", "🗿", "💳", "🧬", "🎒", "🌵", "🌻", "🍇",
    "⛓", "🦋", "🍁", "🌈", "🧀", "🏄🏽‍♀️", "🚂", "🦠", "🐳"
  ]
  
  private var cards:[CardViewController] = {
    return []
  }()

  private var selectedCard1: CardViewController?
  private var selectedCard2: CardViewController?
  private var numberOfTurns: Int = 0
  
  private let backgroundImageView = UIImageView(image: UIImage(named: "table")!)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    backgroundImageView.contentMode = .scaleToFill
    view.addSubview(backgroundImageView)
    
    prepareCards()
  }
  
  override func viewDidLayoutSubviews() {
    backgroundImageView.frame = view.bounds
    layoutCards()
  }
  
  func prepareCards() {
    
    print("Preparing cards (rows=\(rows), cols=\(cols))")
    
//    let preparedMessages = preparedMessagesLinear()
    let preparedMessages = preparedMessagesRandom()
    
    for r in 0..<rows {
      for c in 0..<cols {
        
        let card = CardViewController()
        let index = (r * cols) + c
        card.number = index+1
        card.message = preparedMessages[index]
        card.tapCallback = handleBackTapped
        cards.append(card)
        
        addChild(card)
        view.addSubview(card.view)
        card.didMove(toParent: self)
      }
    }
  }
  
  func layoutCards() {
    
    print("Laying out \(cards.count) cards")
    
    let size = self.view.frame.size
    let cardHeight = floorf((Float(size.height) - (Float(rows) + 1) * spacing) / Float(rows))
    let cardWidth = floorf((Float(size.width) - (Float(cols) + 1) * spacing) / Float(cols))
    
    for i in 0..<cards.count {
      let xIndex = i % cols
      let yIndex = i / cols
      let x = (Float(xIndex + 1) * spacing) + (Float(xIndex) * cardWidth)
      let y = (Float(yIndex + 1) * spacing) + (Float(yIndex) * cardHeight)
      let card = cards[i]
      card.view.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(cardWidth), height: CGFloat(cardHeight))
    }
    
  }
  
  func preparedMessagesLinear() -> [String] {
    var e:[String] = []
    //let count = (rows * cols / 2) // GOOD
    let count = Int(ceilf((Float(rows * cols) / 2.0))) // handles an odd number of cards
    for i in 0..<count {
      // always insert two messages
      e.append(messages[i])
      e.append(messages[i])
    }
    return e
  }
  
  func preparedMessagesRandom() -> [String] {
    let shuffedMessages = messages.shuffled()
    var e:[String] = []
    //let count = (rows * cols / 2) // GOOD
    let count = Int(ceilf((Float(rows * cols) / 2.0))) // handles an odd number of cards
    for i in 0..<count {
      // always insert two messages
      e.append(shuffedMessages[i])
      e.append(shuffedMessages[i])
    }
    return e.shuffled()
  }
  
  func handleBackTapped(card: CardViewController) {
    
    // if two cards are already selected, noop
    if selectedCard1 != nil && selectedCard2 != nil {
      print("Two cards already selected, wait it out...")
      return
    }
    
    // don't select the same card twice
    if card == selectedCard1 {
      print("Selected same card")
      return
    }
    
    print("Back tapped")
    card.revealFront()
    
    if selectedCard1 != nil {
      selectedCard2 = card
      checkMatch()
    } else {
      selectedCard1 = card
    }
  }
  
  func checkMatch() {
    
    numberOfTurns = numberOfTurns + 1
    
    if (selectedCard1?.message == selectedCard2?.message) {
      print("Found a match (\(selectedCard1!.message!))!")
      self.selectedCard1?.indicateSuccess()
      self.selectedCard2?.indicateSuccess()
      self.selectedCard1 = nil
      self.selectedCard2 = nil
      checkWin()
    } else {
      print("Match not found, reset")
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.selectedCard1?.reset()
        self.selectedCard2?.reset()
        self.selectedCard1 = nil
        self.selectedCard2 = nil
      }
    }
  }
  
  func checkWin() {
    for card in cards {
      if !card.isRevealed {
        return
      }
    }
    
    print("Game has been won!")
    // show win state
    let gameover = GameOverViewController()
    gameover.numberOfTurns = numberOfTurns
    gameover.tapCallback = {
      // start a new game
      self.resetBoard()
    }
    
    // present child view controller
    addChild(gameover)
    view.addSubview(gameover.view)
    gameover.didMove(toParent: self)
  }
  
  func resetBoard() {
    
    print("Reset the board")
    numberOfTurns = 0
    
    var delay = 0.0;
    for card in cards {
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        card.reset()
      }
      delay = delay + 0.1
    }
    
    DispatchQueue.main.asyncAfter(deadline: .now() + delay + 0.5) {
      for card in self.cards {
        card.dismiss()
      }
      self.cards.removeAll()
      self.prepareCards()
      self.layoutCards()
    }
  }

}

