//
//  KryptoEntityViewModel.swift
//  KryptosGraphein
//
//  Created by Dumitru Paraschiv on 10.06.2022.
//

import Foundation
import CryptoAPI

class KryptoEntityViewModel: ObservableObject, Identifiable {
	
	@Published var krypto: Coin
	private var storage = RealmPersistance()
	
	enum States {
		case up, down, stable
	}
	
	var states: States
	var maxPrice: Double
	var minPrice: Double
	
	init(krypto: Coin) {
		self.krypto = krypto
		self.states = .stable
		self.minPrice = krypto.price
		self.maxPrice = krypto.price
	}
	
	var id: String { self.code }
	var name: String { krypto.name }
	var code: String { krypto.code }
	var imageUrlString: String? { krypto.imageUrl }
	var price: String { String(format: "$ %.02f", krypto.price) }
	var minDisplayPrice: String { String(format: "$ %.02f", minPrice) }
	var maxDisplayPrice: String { String(format: "$ %.02f", maxPrice) }
	
	func update(krypto: Coin) {
		DispatchQueue.main.async {
			self.states = krypto.price < self.krypto.price ? .down : krypto.price > self.krypto.price ? .up : .stable
			
			self.krypto = krypto
			
			if case .success(let kryptoUpdates) = self.storage.getHistory(code: krypto.code) {
				if let min = kryptoUpdates.min(by: { leftKrypto, rightKrypto in
					leftKrypto.price < rightKrypto.price
				}) {
					self.minPrice = min.price
				} else {
					self.minPrice = krypto.price
				}
				
				if let max = kryptoUpdates.min(by: { leftKrypto, rightKrypto in
					leftKrypto.price > rightKrypto.price
				}) {
					self.maxPrice = max.price
				} else {
					self.maxPrice = krypto.price
				}
			}
		}
	}
	
	func getHistogram() -> [Double] {
		let result = self.storage.getHistory(code: krypto.code)
		switch result {
		case .success(let kryptoHistory):
			let last30sHistory = kryptoHistory.filter { krypto in
				guard let timePassed = krypto.createdAt?.timeIntervalSinceNow else { return false }
				return timePassed > -60
			}
			let priceHistory = last30sHistory.map { krypto in
				return krypto.price
			}
			return priceHistory
		default: return []
		}
	}
}

