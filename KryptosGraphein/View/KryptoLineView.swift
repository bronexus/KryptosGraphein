//
//  KryptoLineView.swift
//  KryptosGraphein
//
//  Created by Dumitru Paraschiv on 10.06.2022.
//

import SwiftUI
import Kingfisher

struct KryptoLineView: View {
	@ObservedObject var vm: KryptoEntityViewModel
	
	@State var priceColor: Color = .clear {
		didSet {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
				priceColor = .clear
			}
		}
	}
	
	var body: some View {
		HStack(alignment: .top, spacing: 0.0) {
			KFImage.url(URL(string: vm.imageUrlString ?? "http://cdn.onlinewebfonts.com/svg/img_359860.png"))
				.resizable()
				.scaledToFit()
				.frame(width: 30, height: 30)
				.padding(.top, -4)
			
			VStack(alignment: .leading, spacing: 12) {
				Text(vm.name) +
				Text("  \(vm.code)")
					.fontWeight(.light)
					.foregroundColor(.gray)
				
				HStack(spacing: 12) {
					Text("min:")
						.font(.caption2)
						.foregroundColor(.gray) +
					Text(" \(vm.minDisplayPrice)")
						.font(.caption)
						.fontWeight(.light)
					
					Text("max:")
						.font(.caption2)
						.foregroundColor(.gray) +
					Text(" \(vm.maxDisplayPrice)")
						.font(.caption)
						.fontWeight(.light)
				}
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.padding(.leading, 6)
			
			Text("\(vm.price)")
				.font(.footnote)
				.fontWeight(.light)
				.padding(8)
				.background(RoundedRectangle(cornerRadius: 5).fill(priceColor).animation(.easeInOut))
				.onChange(of: vm.states) { state in
					switch state {
					case .up:
						priceColor = .green
					case .stable:
						priceColor = .gray
					case .down:
						priceColor = .red
					}
				}
				.padding(.top, -8)
		}
		.padding(.vertical, 8)
	}
}

