//
//  UserProfile.swift
//  comood
//
//  Created by Valentinus on 07/04/25.
//

import SwiftUI

class UserProfile: ObservableObject {
    @Published var name: String = ""
    @Published var gender: String = ""
    @Published var image: UIImage? = nil
}
