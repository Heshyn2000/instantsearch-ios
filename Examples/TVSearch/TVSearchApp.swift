//
//  TVSearchApp.swift
//  TVSearch
//
//  Created by Vladislav Fitc on 08/05/2022.
//

import SwiftUI

@main
struct TVSearchApp: App {
  
  let controller = Controller()
  var body: some Scene {
    WindowGroup {
      ContentView(queryInputController: controller.queryInputController,
                  hitsController: controller.hitsController)
    }
  }
  
}
