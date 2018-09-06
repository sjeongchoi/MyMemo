//
//  MemoDAO.swift
//  MyMemo
//
//  Created by stella on 2018. 9. 7..
//  Copyright © 2018년 mabel. All rights reserved.
//

import UIKit
import CoreData

class MemoDAO {
    //관리 객체 컨텍스트를 반환하는 멤버 변수
    lazy var context: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }()
    
    
    //저장된 메모 전체를 가져오기
    
    func fetch() -> [MemoData] {
        var memolist = [MemoData]()
        
        let fetchRequest: NSFetchRequest<MemoMO> = MemoMO.fetchRequest()
        
        let regdataDesc = NSSortDescriptor(key: "regdate", ascending: false)
        fetchRequest.sortDescriptors = [regdataDesc]
        
        do {
            let resultset = try self.context.fetch(fetchRequest)
            
            for record in resultset {
                let data = MemoData()
                
                data.title = record.title
                data.contents = record.contents
                data.regdate = record.regdate! as Date
                data.objectID = record.objectID
                
                if let image = record.image as Data? {
                    data.image = UIImage(data: image)
                }
                memolist.append(data)
            }
        } catch let e as NSError {
            NSLog("Error Occur : %s", e.localizedDescription)
        }
        return memolist
    }
    
    //새 메모를 저장
    func insert(_ data: MemoData) {
        let object = NSEntityDescription.insertNewObject(forEntityName: "Memo", into: self.context) as! MemoMO
        
        object.title = data.title
        object.contents = data.contents
        object.regdate = data.regdate!
        
        if let image = data.image {
            object.image = UIImagePNGRepresentation(image)!
        }
        
        do {
            try self.context.save()
        } catch let e as NSError {
            NSLog("Error Occur : %s", e.localizedDescription)
        }
    }
    
    //메모를 삭제
    func delete(_ objectID: NSManagedObjectID) -> Bool {
        let object = self.context.object(with: objectID)
        self.context.delete(object)
        
        do {
            try self.context.save()
            return true
        } catch let e as NSError {
            NSLog("Error Occur : %s", e.localizedDescription)
            return false
        }
    }
}
