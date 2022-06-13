//
//  KryptosGrapheinApp.swift
//  KryptosGraphein
//
//  Created by Dumitru Paraschiv on 10.06.2022.
//

import SwiftUI

@main
struct KryptosGrapheinApp: App {
	@StateObject var vm = KryptosViewModel()
	
	var body: some Scene {
		WindowGroup {
			NavigationView {
				HomeView()
			}
			.navigationViewStyle(StackNavigationViewStyle())
			.environmentObject(vm)
		}
	}
}
