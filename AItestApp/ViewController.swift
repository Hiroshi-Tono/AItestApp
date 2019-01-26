//
//  ViewController.swift
//  AItestApp
//
//  Created by 遠野ひろし on 2019/01/24.
//  Copyright © 2019 遠野工房. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextView: UITextView!
    
    // カメラロールを表示するimagePicker
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // imagePickerと、テキストビューを初期化
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        myTextView.text = ""
    }
    
    @IBAction func tapButton(_ sender: Any) {
        // カメラロールを表示する
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // カメラロールで処理が終わった時に呼び出される
    func imagePickerController(_ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : Any]) {
        // カメラロールを閉じて
        imagePicker.dismiss(animated: true, completion: nil)
        // 選択した画像が存在すれば
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        // イメージビューの表示する
        myImageView.image = image
    }
}
