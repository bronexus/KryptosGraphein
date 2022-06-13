//
//  KryptoDetailsView.swift
//  KryptosGraphein
//
//  Created by Dumitru on 11.06.2022.
//

import SwiftUI
import SwiftUICharts
import Kingfisher

struct KryptoDetailsView: View {
	@ObservedObject var vm: KryptoEntityViewModel
	
	var body: some View {
		VStack {
			HStack {
				KFImage.url(URL(string: vm.imageUrlString ?? "http://cdn.onlinewebfonts.com/svg/img_359860.png"))
					.resizable()
					.scaledToFit()
					.frame(width: 120, height: 120)
				
				VStack(alignment: .leading, spacing: 12) {
					Text(vm.name)
						.font(.title2) +
					Text("  \(vm.code)")
						.fontWeight(.light)
						.foregroundColor(.gray)
					
					Text("min:")
						.foregroundColor(.gray) +
					Text(" \(vm.minDisplayPrice)")
						.fontWeight(.light)
					
					Text("max:")
						.foregroundColor(.gray) +
					Text(" \(vm.maxDisplayPrice)")
						.fontWeight(.light)
				}
				
				Spacer()
			}
			
			Spacer()
			
			if let priceHistory = vm.getHistogram() {
				LineView(data: priceHistory)
			}
		}
		.padding(.horizontal)
	}
}
