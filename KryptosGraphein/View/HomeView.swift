//
//  HomeView.swift
//  KryptosGraphein
//
//  Created by Dumitru Paraschiv on 10.06.2022.
//

import SwiftUI

struct HomeView: View {
	@EnvironmentObject var vm: KryptosViewModel
	
	var body: some View {
		ZStack {
			VStack {
				if let kryptos = vm.kryptoModels {
					List(kryptos) { entity in
						ZStack {
							NavigationLink("", destination: KryptoDetailsView(vm: entity))
								.opacity(0.0)
							KryptoLineView(vm: entity)
						}
					}
					.listStyle(PlainListStyle())
				} else {
					ProgressView()
				}
			}
		}
		.navigationTitle("Crypto Currencies")
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView()
	}
}
