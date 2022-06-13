//
//  KryptosViewModel.swift
//  KryptosGraphein
//
//  Created by Dumitru Paraschiv on 10.06.2022.
//

import Foundation
import CryptoAPI

class KryptosViewModel: ObservableObject {
	
	private var kryptoFetcher: KryptoFetchable
	@Published var kryptoModels: [KryptoEntityViewModel]?
	private var storage: DataPersistable?
	
	init() {
		kryptoFetcher = KryptoFetcher()
		storage = RealmPersistance()
		getAllKryptos()
		kryptoFetcher.startFetching { krypto in
			self.save(krypto: krypto)
			self.updateViewModels(krypto: krypto)
		}
	}
	
	private func getAllKryptos() {
		let kryptos = self.kryptoFetcher.getAllCoins()
		let kryptoEntities = kryptos.map { krypto in
			return KryptoEntityViewModel(krypto: krypto)
		}
		
		self.kryptoModels = kryptoEntities
	}
	
	private func save(krypto: Coin) {
		DispatchQueue.main.async { [weak self] in
			guard let self = self else { return }
			guard let storage = self.storage else { return }
			
			let storedKrypto = StoredKrypto()
			storedKrypto.name = krypto.name
			storedKrypto.imageUrl = krypto.imageUrl
			storedKrypto.price = krypto.price
			storedKrypto.code = krypto.code
			_ = storage.save(krypto: storedKrypto)
		}
	}
	
	private func updateViewModels(krypto: Coin) {
		if let mainModel = self.kryptoModels?.first(where: { sourceModel in
			sourceModel.code == krypto.code
		}) {
			mainModel.update(krypto: krypto)
		}
	}
}
