//
//  LocalStorage.swift
//  BabyProduct
//
//  Created by Artem Kupriianets on 27.06.2021.
//

import UIKit

final class LocalStorage {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
}

// MARK: - Private

private extension LocalStorage {

    enum Key: String, CaseIterable {
        case childCredentials
        case childPhoto
    }

    func setString(_ value: String?, for key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    func getString(for key: Key) -> String? {
        userDefaults.value(forKey: key.rawValue) as? String
    }

    func setObject<T: Encodable>(_ value: T?, for key: Key) {
        if let encodedData = try? JSONEncoder().encode(value) {
            userDefaults.set(encodedData, forKey: key.rawValue)
        }
    }

    func getObject<T: Decodable>(for key: Key) -> T? {
        if let data = userDefaults.object(forKey: key.rawValue) as? Data {
            return try? JSONDecoder().decode(T.self, from: data)
        }
        return nil
    }

    func clearUserDefaults() {
        userDefaults
            .dictionaryRepresentation()
            .keys
            .forEach(
                userDefaults.removeObject(forKey:)
            )
        userDefaults.synchronize()
    }
}

extension LocalStorage: ChildDataStoring {

    var didStoreChildPhoto: Bool {
        guard let url = fileURL(forKey: Key.childPhoto.rawValue) else { return false }
        return FileManager.default.fileExists(atPath: url.path)
    }

    var childCredentials: ChildCredentials? {
        get {
            getObject(for: .childCredentials)
        }
        set {
            setObject(newValue, for: .childCredentials)
        }
    }

    var childPhoto: UIImage? {
        get {
            getImage()
        }
        set {
            saveImage(newValue)
        }
    }

    private func getImage() -> UIImage? {
        guard let url = fileURL(forKey: Key.childPhoto.rawValue) else { return nil }
        if let data = FileManager.default.contents(atPath: url.path) {
            return UIImage(data: data)
        }
        return nil
    }

    private func saveImage(_ image: UIImage?) {
        let key: Key = .childPhoto
        if let data = image?.pngData(),
           let url = fileURL(forKey: key.rawValue) {
            do {
                try data.write(to: url)
            } catch {
                debugPrint("Unable to Write Data to Disk: \(error)")
            }
        }
    }

    private func fileURL(forKey key: String) -> URL? {
        guard let documentURL = FileManager.default.urls(
            for: .documentDirectory,
            in: FileManager.SearchPathDomainMask.userDomainMask
        ).first else { return nil }

        return documentURL.appendingPathComponent(key + ".png")
    }
}
