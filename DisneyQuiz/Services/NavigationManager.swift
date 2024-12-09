//
//  NavigationManager.swift
//  DisneyQuiz
//
//  Created by James Kim on 11/27/24.
//

import Foundation
import SwiftUI


@Observable class NavigationManager {
    var path = NavigationPath()
    
    func popToRoot() {
        path = NavigationPath()
    }
    func goBack() {
        print(path)
        if path.count > 0 {
              path.removeLast()
        }
    }
}
