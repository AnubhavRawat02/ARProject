//
//  DataController.swift
//  ARProject
//
//  Created by Anubhav Rawat on 03/10/22.
//

import Foundation
import CoreData

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "DataModels")
    init(){
        container.loadPersistentStores { discription, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
}
