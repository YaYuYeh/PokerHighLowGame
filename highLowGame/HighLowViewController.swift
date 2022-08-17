//
//  HighLowViewController.swift
//  highLowGame
//
//  Created by yeh on 2022/8/17.
//

import UIKit

class HighLowViewController: UIViewController
{
    
    @IBOutlet weak var computerLabel: UILabel!
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var chipsLabel: UILabel!
    @IBOutlet weak var betsTextField: UITextField!
    @IBOutlet weak var betsStepper: UIStepper!
    @IBOutlet weak var showHandButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    
    
    
    //產生一個撲克牌空陣列
    var cards = [Card]()
    var chips = 1000
    //宣告儲存下注金額的變數
    var bets:Int = 0
    
    
    
    //整副牌52張牌的方法
    func createCard()
    {
        let suits = ["♣︎", "♦", "♥", "♠"]
        let ranks = ["2", "3", "4", "5", "6","7", "8", "9", "10", "J", "Q", "K", "A"]
        
        for suit in suits
        {
            for rank in ranks
            {
                let card = Card(suit: suit, rank: rank)
                cards.append(card)
            }
        }
    }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //放在viewDidLoad()中，打開app時就會產生52張牌
        createCard()
        replayButton.isHidden = true
        
    }
    
    
    
    //點擊stepper決定下注金額
    @IBAction func betsAdd(_ sender: UIStepper)
    {
        //將stepper的數值轉為整數
        bets = Int(sender.value)
        //再轉為字串傳入textField
        betsTextField.text = String(bets)
        //若下注金額大於本金籌碼，stepper關閉？？？？
        if bets == chips
        {
            sender.isEnabled = true
        }
        if Int(sender.value) > chips
        {
            bets = chips
            betsTextField.text = String(bets)
            
        }
        
    }
    
    
    @IBAction func showHand(_ sender: UIButton)
    {
        bets = chips
        betsTextField.text = String(bets)
    }
    
    
    
    //給予rank分數以分辨大小
    func getCardRankScore(rank:String) -> Int
    {
        var rankScore = 0
        switch rank
        {
            case "A":
                rankScore = 14
            case "K":
                rankScore = 13
            case "Q":
                rankScore = 12
            case "J":
                rankScore = 11
            default:
                rankScore = Int(rank)!
        }
        return rankScore
    }
    //給予suit分數以分辨大小
    func getCardSuitScore(suit:String) -> Int
    {
        var suitScore = 0
        switch suit
        {
            case "♠":
                suitScore = 4
            case "♥":
                suitScore = 3
            case "♦":
                suitScore = 2
            case "♣︎":
                suitScore = 1
            default:
                break
        }
        return suitScore
    }
    //若花色是♥或♦，字體顏色為紅色，反之為黑色
    func cardColor(suit:String) -> UIColor
    {
        switch suit
        {
            case "♥", "♦":
                return UIColor.red
            default:
                return UIColor.black
        }
    }
    
    
    @IBAction func play(_ sender: UIButton)
    {
        //避免重複，按play後洗牌
        cards.shuffle()
        //電腦由整副牌中取第一張牌，使用者取第二張牌，型別為Card
        let computerCard = cards[0]
        let playerCard = cards[1]
        //顯示電腦及使用者拿到的牌
        computerLabel.text = "\(computerCard.suit)\(computerCard.rank)"
        computerLabel.textColor = cardColor(suit: computerCard.suit)
        playerLabel.text = "\(playerCard.suit)\(playerCard.rank)"
        playerLabel.textColor = cardColor(suit: playerCard.suit)
        
        
        //比較card大小，贏：籌碼+100，輸：籌碼-100
        //由getCardRankScore函式得知電腦及使用者的rank大小，來比較輸贏
        let computerRankScore = getCardRankScore(rank: computerCard.rank)
        let playerRankScore = getCardRankScore(rank: playerCard.rank)
        if playerRankScore > computerRankScore
        {
            resultLabel.text = "不賴嘛，你贏了！"
            chips += bets
            
        }
        else if playerRankScore < computerRankScore
        {
            resultLabel.text = "你輸了，太弱囉！"
            chips -= bets
        }
        //拿到相同rank的牌後，透過花色比較大小
        else
        {
            //由getCardSuitScore函式得知電腦及使用者的suit大小，來做比較
            let computerSuitScore = getCardSuitScore(suit: computerCard.suit)
            let playerSuitScore =
            getCardSuitScore(suit: playerCard.suit)
            if playerSuitScore > computerSuitScore
            {
                resultLabel.text = "不賴嘛，你贏了！"
                chips += bets
            }
            else
            {
                resultLabel.text = "你輸了，太弱囉！"
                chips -= bets
            }
        }
        //每次play將下注金額歸零，避免下注金額大於籌碼
        //bets = 0
        //顯示當次play後，籌碼剩多少
        chipsLabel.text = "$\(chips)"
        //當籌碼小於等於0時，顯示破產訊息，並關閉Play按鈕
        if chips <= 0
        {
            resultLabel.text = "沒錢拉，重玩吧魯蛇"
            playButton.isHidden = true
            showHandButton.isHidden = true
            replayButton.isHidden = false
        }
    }
    
    @IBAction func replay(_ sender: Any)
    {
        chips = 1000
        chipsLabel.text = "$\(chips)"
        bets = 0
        betsTextField.text = String(bets)
        resultLabel.text = "開始吧！"
        playButton.isHidden = false
        showHandButton.isHidden = false
        replayButton.isHidden = true
    }
}
