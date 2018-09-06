//
//  MemoData.swift
//  MyMemo
//
//  Created by stella on 2018. 9. 3..
//  Copyright © 2018년 mabel. All rights reserved.
//

import UIKit
import CoreData

class MemoData {
    var memoIdx : Int?
    var title : String?
    var contents : String?
    var image : UIImage?
    var regdate : Date?
    
    //추가
    var objectID : NSManagedObjectID?
}
