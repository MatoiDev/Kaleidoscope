//
//  StreamViewController.swift
//  Kaleidoscope
//
//  Created by Erast (MatoiDev) on 09.08.2024.
//  Copyright © 2024 Erast (MatoiDev). All rights reserved.
//

import UIKit


protocol StreamViewControllerPresenter: AnyObject {
    func dismiss() -> Void
}

final class StreamViewController: UIViewController {
    
    // Properties
    private var kandinskyService: KandinskyAPIService
    private let configuration: SettingsConfiguration
    private var timer: Timer?
    private var isWaitingForImage: Bool = false
    private var nextImage: UIImage?
    
    init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil, configuration: SettingsConfiguration) {
        self.configuration = configuration
        kandinskyService = KandinskyAPIService()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        startImageFlow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cancelTimer()
        kandinskyService.cancel()
    }
    
    override var prefersStatusBarHidden: Bool { true }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension StreamViewController {
    
    func setupView() -> Void {
        let view: StreamView = StreamView()
        view.presenter = self
        self.view = view
    }
    
    func startImageFlow() -> Void {
        loadImage()
    }
    
    func loadImage() {
        
        self.kandinskyService.getImage(with: self.configuration) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.handleImageLoadSuccess(image)
                }
            case .failure(let error):
                guard let error = error as? URLError, error != URLError(.cancelled) else { return }
                self.raiseAlert(title: "Error", message: error.localizedDescription)
            }
        }
    }
    
    func handleImageLoadSuccess(_ image: UIImage) {
        if let _ = timer {
            nextImage = image
            isWaitingForImage = true
        } else {
            updateView(with: image)
            startTimer()
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: configuration.state.interval, target: self, selector: #selector(timerDidEnd), userInfo: nil, repeats: false)
    }
    
    @objc func timerDidEnd() {
        cancelTimer()
        
        if let image = nextImage {
            updateView(with: image)
            nextImage = nil
        }
        
        loadImage()
        startTimer()
    }
    
    func cancelTimer() -> Void {
        timer?.invalidate()
        timer = nil
    }
    
    func updateView(with image: UIImage) {
        guard let view = (self.view as? StreamView) else { return }
        view.updateView(with: image)
    }
    
    func raiseAlert(title: String, message: String) -> Void {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlertAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAlertAction)
        present(alert, animated: true)
    }
}

extension StreamViewController: StreamViewControllerPresenter {
    func dismiss() -> Void {
        dismiss(animated: true)
    }
}
