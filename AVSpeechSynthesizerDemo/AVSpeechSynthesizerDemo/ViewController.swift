//
//  ViewController.swift
//  AVSpeechSynthesizerDemo
//
//  Created by 马伟 on 2017/6/16.
//  Copyright © 2017年 马伟. All rights reserved.
//

import UIKit
import AVFoundation

let kReuseCellId = "cell"

class ViewController: UIViewController {

    @IBOutlet weak var displayTableView: UITableView!
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var inputViewBottonCons: NSLayoutConstraint!
    
    lazy var dataSource = Array<Any>()
    
    
    lazy var synthesizer : AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "AVSpeechSynthesizer"
        
//        displayTableView.tableFooterView = UIView()
        displayTableView.register(UITableViewCell.self, forCellReuseIdentifier: kReuseCellId)
        displayTableView.separatorInset = .zero
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardFrameChangeAction(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        synthesizer.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        
    }

    @objc func keyboardFrameChangeAction(_ noti : Notification) {
        
        let duration = noti.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let beginRect = noti.userInfo?[UIKeyboardFrameBeginUserInfoKey] as! CGRect
        let endRect = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        let dif_y = beginRect.origin.y - endRect.origin.y
        
        UIView.animate(withDuration: duration) {
            self.inputViewBottonCons.constant += dif_y
        }
    }
    
    
    @IBAction func speechButtonClick(_ sender: Any) {
        
//        view.endEditing(true)
        
        if (inputTextView.text != nil) {
            
            let utterance = AVSpeechUtterance(string: inputTextView.text)
            if synthesizer.isSpeaking {return}
            synthesizer.speak(utterance)
        }
        
        
    }
    
}


extension ViewController : AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
        dataSource.append(utterance.speechString)
        displayTableView.reloadData()
        displayTableView.scrollToRow(at: IndexPath.init(row: dataSource.count - 1, section: 0), at: .bottom, animated: true)
    }
}


extension ViewController : UITableViewDataSource, UITextViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: kReuseCellId, for: indexPath)
        let speechText = dataSource[indexPath.row] as! String
        cell.textLabel?.text = speechText
        
        if indexPath.row % 2 == 0 {
            cell.textLabel?.textAlignment = .right
            cell.textLabel?.textColor = UIColor.blue
        } else {
            cell.textLabel?.textAlignment = .left
            cell.textLabel?.textColor = UIColor.cyan
        }
        
        return cell
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
       
        if text == "\n" {
        
            view.endEditing(true)
            return false
        }
        return true
    }
    

}



//extension UITableViewCell {
//
//    open override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        textLabel?.frame = bounds
//    }
//}








