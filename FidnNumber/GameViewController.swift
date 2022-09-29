//
//  GameViewController.swift
//  FidnNumber
//
//  Created by Nur_013 on 25/5/22.
//

import UIKit


class GameViewController: UIViewController {
   
    @IBOutlet var buttons: [UIButton]!
   
    @IBOutlet weak var newDigit: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var newGameButton: UIButton!
    
    lazy var game = Game(countItems: buttons.count) { [weak self] (status, time) in
        
        guard let self = self else {return}
        
        self.timerLabel.text = time.secondToString()
    
        self.updateInfoGame(with: status)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        game.stopGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScreen()
    }
    
    @IBAction func pressButton(_ sender: UIButton) {
        guard let buttonIndex = buttons.firstIndex(of: sender) else {return}
        
        game.check(index:buttonIndex)
        
        updateUI()
}
    @IBAction func newGame(_ sender: UIButton) {
        game.newGame()
        
        sender.isHidden = true
        
        setupScreen()
    }
    private func setupScreen(){
        for index in game.items.indices{
            buttons[index].setTitle(game.items[index].title, for: .normal)
            
            buttons[index].alpha = 1
            
            buttons[index].isEnabled = true
        }
        newDigit.text = game.nextItem?.title
    }
    private func updateUI(){
        for index in game.items.indices{
            buttons[index].alpha = game.items[index].isFound ? 0 : 1
            
            buttons[index].isEnabled = !game.items[index].isFound
            
            if game.items[index].isError{
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.buttons[index].backgroundColor = .red
                } completion: { [weak self](_) in
                    self?.buttons[index].backgroundColor = .white
                    
                    self?.game.items[index].isError = false
                }
            }
        }
        newDigit.text = game.nextItem?.title
        
        updateInfoGame(with: game.status)
    }
    private func updateInfoGame(with status:StatusGame){
        switch status{
        
        case .start:
            statusLabel.text = "Игра началась!"
            
            statusLabel.textColor = .black
            
            newGameButton.isHidden = true
        case .win:
            statusLabel.text = "Вы выиграли!"
            
            statusLabel.textColor = .blue
            
            newGameButton.isHidden = false
            
            if game.isRecord{
                showAlert()
            
            }else{
                showAlertActionSheet()
            }
        case .lose:
            statusLabel.text = "Ты лох, потому что проиграл!"
        
            statusLabel.textColor = .red
            
            newGameButton.isHidden = false
            
            showAlertActionSheet()
        }
    }
    private func showAlert(){
        let alert = UIAlertController.init(title: "Молодец!", message: "Вы установили новый рекорд!", preferredStyle: .alert)

        let okAlert = UIAlertAction.init(title: "OK", style: .default, handler: nil)

        alert.addAction(okAlert)

        present(alert, animated: true, completion: nil)
    }
    private func showAlertActionSheet(){
        let alert = UIAlertController(title: "Что вы хотите сделать дальше?", message: nil, preferredStyle: .actionSheet)
        
        let newGameAction = UIAlertAction(title: "Начать новую игру", style: .default) { [weak self] (_) in
            self?.game.newGame()
            
            self?.setupScreen()
        }
        
        let showRecord = UIAlertAction(title: "Посмотреть рекорд", style: .default) { [weak self] (_) in
            self?.performSegue(withIdentifier: "recordVC", sender: nil)
        }
        
        let menuAction = UIAlertAction(title: "Перейти в меню", style: .destructive) { [weak self] (_) in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(newGameAction)
        alert.addAction(showRecord)
        alert.addAction(menuAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        }
    }

