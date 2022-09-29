//
//  RecordViewController.swift
//  FidnNumber
//
//  Created by Nur_013 on 13/8/22.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let record = UserDefaults.standard.integer(forKey: KeysUserDefaults.recordGame)
       
        if record != 0 {
            recordLabel.text = "Ваш рекорд - \(record)"
        }else{
            recordLabel.text = "Рекорда еще не было"
        }
    }
    @IBAction func closeVC(_ sender: Any) {
        dismiss(animated: true, completion: nil )
    }
}
