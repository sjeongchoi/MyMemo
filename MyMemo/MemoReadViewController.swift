//
//  MemoReadViewController.swift
//  MyMemo
//
//  Created by stella on 2018. 9. 3..
//  Copyright © 2018년 mabel. All rights reserved.
//

import UIKit
import FontBlaster

class MemoReadViewController: UIViewController {
    var param: MemoData?
    @IBOutlet var subject: UILabel!
    @IBOutlet var contents: UILabel!
    @IBOutlet var img: UIImageView!
    
    override func viewDidLoad() {
        self.subject.text = param?.title
        self.contents.text = param?.contents
        self.img.image = param?.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd일 HH:mm분에 작성됨"
        let dateString = formatter.string(from: (param?.regdate)!)
        
        self.navigationItem.title = dateString

        FontBlaster.debugEnabled = true
        FontBlaster.blast { (fonts) -> Void in
            print("Loaded Fonts", fonts)
        }
        contents.font = UIFont(name: "SDMiSaeng", size: 20)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
