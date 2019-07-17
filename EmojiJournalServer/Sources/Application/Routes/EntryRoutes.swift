//
//  EntryRoute.swift
//  Application
//
//  Created by Haris Kumar S on 17/07/19.
//

import Foundation
import Kitura
import LoggerAPI

func initializeEntryRoutes(app : App){
    Log.info("Entry level journals created")
    app.router.post("/entries")
}

