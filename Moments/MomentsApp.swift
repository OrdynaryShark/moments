//
//  MomentsApp.swift
//  Moments
//
//  Created by Andrew on 26.11.2022.
//

import SwiftUI

@main
struct MomentsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(MemosStore())
        }
    }
}
