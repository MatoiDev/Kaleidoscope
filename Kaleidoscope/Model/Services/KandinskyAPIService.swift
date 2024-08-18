//
//  KandinskyAPIService.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 08.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import Foundation
import UIKit


final class KandinskyAPIService {
    
    enum ServiceError: Error {
        case missingAPIOrSecretKey
        case missingPrompt
        case cannotDecodeImage
    }
    
    // Properties
    private let decoder: JSONDecoder = JSONDecoder()
    private var api: Text2ImageAPI?
    
    func getImage(with configuration: SettingsConfiguration, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> Void {
        
        guard let apiKey: String = configuration.state.apiKey, let secretKey: String = configuration.state.secretKey else { completion(.failure(ServiceError.missingAPIOrSecretKey)); return }
        guard let prompt: String = configuration.state.prompt else { completion(.failure(ServiceError.missingPrompt)); return }
        
        api = Text2ImageAPI(url: "https://api-key.fusionbrain.ai/", apiKey: apiKey, secretKey: secretKey)
    
        
        api?.getModel {[weak self] modelCompletion in
            guard let self = self else { completion(.failure(URLError(.cancelled))); return }
            switch modelCompletion {
            case .success(let modelId):
                self.api?.generate(prompt: prompt, negativePrompt: configuration.state.negativePrompt, style: configuration.state.style, model: modelId) { uuidCompletion in
                    switch uuidCompletion {
                    case .success(let uuid):
                        self.api?.checkGeneration(requestId: uuid) { images in
                            switch images {
                            case .success(let result):
                                guard
                                    let imageBase64Code: String = result.first,
                                    let data = Data(base64Encoded: imageBase64Code),
                                    let image = UIImage(data: data)
                                    else { completion(.failure(ServiceError.cannotDecodeImage)); return }
                                completion(.success(image))
                            case .failure(let failure):
                                 completion(.failure(failure))
                            }
                         
                        }
                    case .failure(let failure):
                        completion(.failure(failure))
                    }
                }
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func fetchStyles(_ completion: @escaping (Result<[KandinskyStyles], Error>) -> Void) -> Void {
        let url: URL = URL(string: "http://cdn.fusionbrain.ai/static/styles/api")!
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self else { completion(.failure(URLError(.cancelled))); return }
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { completion(.failure(URLError(.cannotParseResponse))); return }
            do {
                let result: [KandinskyStyles] = try self.decoder.decode([KandinskyStyles].self, from: data)
                completion(.success(result)); return
            } catch {
                completion(.failure(error)); return
            }
        }.resume()
    }
    
    func cancel() -> Void {
        api?.cancell()
    }
}


fileprivate class Text2ImageAPI {

    let url: String
    let authHeaders: [String: String]
    var isCancelled: Bool = false

    init(url: String, apiKey: String, secretKey: String) {
        self.url = url
        self.authHeaders = [
            "X-Key": "Key \(apiKey)",
            "X-Secret": "Secret \(secretKey)"
        ]
    }
    
    func cancell() -> Void {
        isCancelled = true
    }

    private func createRequest(for endpoint: String, method: String = "GET") -> URLRequest? {
        guard let url = URL(string: "\(self.url)\(endpoint)") else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        authHeaders.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        return request
    }

    func getModel(completion: @escaping (Result<String, Error>) -> Void) {
        guard let request = createRequest(for: "key/api/v1/models") else { return }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.cannotParseResponse)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]], let modelId = json.first?["id"] as? Int {
                    completion(.success(String(modelId)))
                } else {
                    completion(.failure(URLError(.cannotDecodeRawData)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func generate(prompt: String, negativePrompt: String?, style: String?, model: String, images: Int = 1, width: Int = 1024, height: Int = 680, completion: @escaping (Result<String, Error>) -> Void) {
        guard var request = createRequest(for: "key/api/v1/text2image/run", method: "POST") else { return }
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let params: [String: Any] = [
            "type": "GENERATE",
            "style": style ?? "DEFAULT",
            "numImages": images,
            "width": width,
            "height": height,
            "negativePromptUnclip": negativePrompt ?? "",
            "generateParams": [
                "query": prompt
            ]
        ]
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"model_id\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(model)\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"params\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)
        body.append((try? JSONSerialization.data(withJSONObject: params, options: [])) ?? Data())
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.cannotParseResponse)))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let uuid = json["uuid"] as? String {
                    completion(.success(uuid))
                } else {
                    completion(.failure(URLError(.cannotDecodeRawData)))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func checkGeneration(requestId: String, attempts: Int = 100, delay: TimeInterval = 1, completion: @escaping (Result<[String], Error>) -> Void) {
        var remainingAttempts = attempts

        func check() {
            guard !isCancelled, remainingAttempts > 0 else {
                completion(.failure(URLError(.cancelled)))
                return
            }
            
            guard let request = createRequest(for: "key/api/v1/text2image/status/\(requestId)") else { return }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? URLError(.cannotParseResponse)))
                    return
                }
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let status = json["status"] as? String, status == "DONE",
                       let images = json["images"] as? [String] {
                        completion(.success(images))
                    } else {
                        remainingAttempts -= 1
                        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
                            check()
                        }
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
        check()
    }
}

