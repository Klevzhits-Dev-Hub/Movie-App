//
//  WebViewController.swift
//  Movie App
//
//  Created by Artem Kriukov on 07.04.2025.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private let webView = WKWebView()
    private let url: URL
    var onDismiss: (() -> Void)?
    
    init(url: URL, onDismiss: (() -> Void)? = nil) {
        self.url = url
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadRequest()
        setupNavigationBar()
        setupPresentationController()
    }
    
    private func setupPresentationController() {
        isModalInPresentation = false
        presentationController?.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissController)
        )
    }
    
    @objc private func dismissController() {
        dismiss(animated: true, completion: onDismiss)
    }
    
    
    
    private func setupWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadRequest() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

extension WebViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        onDismiss?()
    }
}
