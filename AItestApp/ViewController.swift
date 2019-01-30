//
//  ViewController.swift
//  AItestApp
//
//  Created by 遠野ひろし on 2019/01/24.
//  Copyright © 2019 遠野工房. All rights reserved.
//

import UIKit

import CoreML
import Vision

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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // カメラロールを閉じて
        imagePicker.dismiss(animated: true, completion: nil)
        // 選択した画像が存在すれば
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        // イメージビューの表示する
        myImageView.image = image
        
        // 画像を予測する
        predict(inputImage: image)
    }
    
    // 画像を予測する
    func predict(inputImage: UIImage) {
        self.myTextView.text = ""
        // 機械学習のモデルを作る
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
            return
        }
        
        // モデルのリクエストを作り、予測結果が帰ってきたとき表示する
        let request = VNCoreMLRequest(model: model) {
            request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                return
            }
            for result in results {
                // 確率が1%以上のものをテキストビューに追加する
                let per = Int(result.confidence * 100)
                if per >= 1 {
                    let name = result.identifier
                    self.myTextView.text.append("これは、\(name)です。確率は\(per)% \n")
                }
            }
        }
        // 画像を学習モデルに渡せる形式に変換する
        guard let ciImage = CIImage(image: inputImage) else {
            return
        }
        let imageHandler = VNImageRequestHandler(ciImage: ciImage)
        do {
            // 画像予測を実行する
            try imageHandler.perform([request])
        } catch {
            print("エラー \(error)")
        }
    }
}
