//
//  MemoListTableViewController.swift
//  MyMemo
//
//  Created by stella on 2018. 9. 3..
//  Copyright © 2018년 mabel. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class MemoListTableViewController: UITableViewController, EmptyDataSetSource, EmptyDataSetDelegate {
    
    //추가
    lazy var dao = MemoDAO()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        //추가
        //코에 데이터에 저장된 값을 가져옴
        self.appDelegate.memolist = self.dao.fetch()
        
        //데이터를 다시 읽어들임.
        self.tableView.reloadData()
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 250))
//        view.backgroundColor = .red
        let image = UIImage(named: "no_found.png")
        let imageView = UIImageView(image: image!)
        
        view.addSubview(imageView)
        return view
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.appDelegate.memolist.count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = self.appDelegate.memolist[indexPath.row]
        
        let cellId = row.image == nil ? "memoCell" : "memoCellWithImage"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! MemoCell
        
        cell.subject?.text = row.title
        cell.contents?.text = row.contents
        cell.img?.image = row.image
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        cell.regdate?.text = formatter.string(from: row.regdate!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = self.appDelegate.memolist[indexPath.row]
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MemoRead") as? MemoReadViewController else {
            return
        }
        
        vc.param = row
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let data = self.appDelegate.memolist[indexPath.row]
        
        // 코어 데이터에서 삭제한 다음, 배열 내 데이터 및 테이블 뷰 행을 차례로 삭제한다.
        if dao.delete(data.objectID!) {
            self.appDelegate.memolist.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
