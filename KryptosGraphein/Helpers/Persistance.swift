//
//  Persistance.swift
//  KryptosGraphein
//
//  Created by Dumitru Paraschiv on 10.06.2022.
//

import Foundation
import RealmSwift

protocol DataPersistable {
	func getHistory(code: String) -> Result<[StoredKrypto], PersistanceEror>
	func getLastValue(code: String) -> Result<StoredKrypto, PersistanceEror>
	func getUpdates(code: String, seconds: Int) -> Result<[StoredKrypto], PersistanceEror>
	func save(krypto: StoredKrypto) -> PersistanceEror?
}

class StoredKrypto: Object {
	@Persisted var name: String = ""
	@Persisted var code: String = ""
	@Persisted var price: Double = 0.0
	@Persisted var imageUrl: String?
	@Persisted var createdAt: Date? = Date()
}

enum PersistanceEror: Error {
	case noData
	case instantiationError
	case sourceInitializationError(error: Error)
	case writeError(error: Error)
}

class RealmPersistance: DataPersistable {
	
	var realm: Realm?
	
	init() {
		do { realm = try Realm() }
		catch(let error) { print("Realm error: \(error)") }
	}
	
	func getHistory(code: String) -> Result<[StoredKrypto], PersistanceEror> {
		guard let realm = realm else { return .failure(.instantiationError) }
		
		let kryptos = realm.objects(StoredKrypto.self)
		let kryptosWithCode = kryptos.where {
			$0.code == code
		}
		
		return .success(Array(kryptosWithCode))
	}
	
	func getLastValue(code: String) -> Result<StoredKrypto, PersistanceEror> {
		let result = self.getHistory(code: code)
		switch result {
		case .success(let storedKryptos):
			guard let lastUpdate = storedKryptos.last else { return .failure(.noData) }
			return .success(lastUpdate)
		case .failure(let error):
			return .failure(error)
		}
	}
	
	func getUpdates(code: String, seconds: Int) -> Result<[StoredKrypto], PersistanceEror> {
		let result = self.getHistory(code: code)
		guard case .success(let lastUpdates) = result else { return result }
		
		let updatesForLast = lastUpdates.filter { krypto in
			guard let createdAt = krypto.createdAt else { return false }
			return createdAt.timeIntervalSince1970 > Date().timeIntervalSince1970 - Double(seconds)
		}
		
		return .success(updatesForLast)
	}
	
	func save(krypto: StoredKrypto) -> PersistanceEror? {
		guard let realm = realm else { return .instantiationError }

		do {
			try realm.write {
				realm.add(krypto)
			}
			return nil
		}
		catch(let error) {
			return .writeError(error: error)
		}
	}
}
