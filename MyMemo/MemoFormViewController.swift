//
//  MemoFormViewController.swift
//  MyMemo
//
//  Created by stella on 2018. 9. 3..
//  Copyright © 2018년 mabel. All rights reserved.
//

import UIKit

class MemoFormViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    var subject: String!

    lazy var dao = MemoDAO()
    
    @IBOutlet var contents: UITextView!
    @IBOutlet var preview: UIImageView!
    
    override func viewDidLoad() {
        self.contents.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: Any) {
        guard self.contents.text?.isEmpty == false else {
            //TODO : alert
            let alert = UIAlertController(title: nil,
                                          message: "내용을 입력해주세요",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        let data = MemoData()
        
        data.title = self.subject
        data.contents = self.contents.text
        data.image = self.preview.image
        data.regdate = Date()
        
        self.dao.insert(data)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pick(_ sender: Any) {
        let select = UIAlertController(title: "이미지를 가져올 곳을 선택해주세요.", message: nil, preferredStyle: .actionSheet)
//        select.addAction(UIAlertAction(title: "카메라", style: .default) { (_) in
//            self.presentPicker(source: .camera)
//        })
        select.addAction(UIAlertAction(title: "저장앨범", style: .default) { (_) in
            self.presentPicker(source: .savedPhotosAlbum)
        })
        select.addAction(UIAlertAction(title: "사진 라이브러리", style: .default) { (_) in
            self.presentPicker(source: .photoLibrary)
        })
        self.present(select, animated: false)
    }
    
    // 실제로 이미지 피커를 실행하는 메소드
    func presentPicker(source: UIImagePickerControllerSourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(source) == true else {
            let alert = UIAlertController(title: "사용할 수 없는 타입입니다", message: nil, preferredStyle: .alert)
            self.present(alert, animated: false)
            return
        }
        
        // 이미지 피커 인스턴스를 생성한다.
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        
        // 이미지 피커 화면을 표시한다.
        self.present(picker, animated: false)
    }
    
    // 이미지 선택을 완료했을 때 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        self.preview.image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        picker.dismiss(animated: false)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let contents = textView.text as NSString
        let length = ((contents.length > 15) ? 15 : contents.length )
        self.subject = contents.substring(with: NSRange(location: 0, length: length))
        self.navigationItem.title = subject
    }

}
