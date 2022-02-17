//
//  ViewController.swift
//  Chuck Norris
//
//  Created by Tiago Caldeira Ortiz Lima on 07/02/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    var jokeLabel: UILabel!
    var         category: UILabel!
    var button: UIButton!
    var stackview: UIStackView!
    var textView: UIView!
    var activeIndicator: UIActivityIndicatorView!
    var searchButton: UIBarButtonItem!
    var errorMessageLabel: UILabel!
    var errorButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Chuck Norris"
        
        //        navigationController?.navigationBar.barStyle = .black
        //        navigationController?.navigationBar.backgroundColor = .orange
        //        navigationController?.navigationBar.isTranslucent = false
        //        navigationController?.navigationBar.tintColor = .orange
        
        textView = UIView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isHidden = true
        view.addSubview(textView)
        
        jokeLabel = UILabel()
        jokeLabel.translatesAutoresizingMaskIntoConstraints = false
        jokeLabel.font = .systemFont(ofSize: 25)
        jokeLabel.numberOfLines = 0
        jokeLabel.textAlignment = .center
        jokeLabel.adjustsFontSizeToFitWidth = true
        textView.addSubview(jokeLabel)
        
        category = JokeCategorieLabel()
        textView.addSubview(category)
        
        button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next fact", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.tintColor = .label
        button.backgroundColor = .systemOrange
        button.layer.cornerRadius = 35
        button.addTarget(self, action: #selector(getJoke), for: .touchUpInside)
        view.addSubview(button)
        
        activeIndicator = UIActivityIndicatorView(style: .large)
        activeIndicator.translatesAutoresizingMaskIntoConstraints = false
        activeIndicator.startAnimating()
        activeIndicator.isHidden = false
        view.addSubview(activeIndicator)
        
        searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(navigateToSearchView))
        searchButton.tintColor = .label
        self.navigationItem.rightBarButtonItem = searchButton
        
        
        errorMessageLabel = UILabel()
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.font = .systemFont(ofSize: 18)
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.text = "An error has occurred, please try again."
        errorMessageLabel.isHidden = true
        view.addSubview(errorMessageLabel)
        
        errorButton = UIButton(type: .system)
        errorButton.translatesAutoresizingMaskIntoConstraints = false
        errorButton.setTitle("Try again", for: .normal)
        errorButton.titleLabel?.font = .systemFont(ofSize: 25)
        errorButton.addTarget(self, action: #selector(getJoke), for: .touchUpInside)
        errorButton.isHidden = true
        view.addSubview(errorButton)
        
        
        NSLayoutConstraint.activate([
            
            jokeLabel.centerXAnchor.constraint(equalTo: textView.centerXAnchor),
            jokeLabel.centerYAnchor.constraint(equalTo: textView.centerYAnchor),
            jokeLabel.widthAnchor.constraint(lessThanOrEqualTo: textView.widthAnchor,multiplier: 0.8),
            
            category.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor,constant: 20),
            category.leadingAnchor.constraint(equalTo: jokeLabel.leadingAnchor, constant: 8),
            
            button.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 70),
            button.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.8),
            
            textView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: button.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            activeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activeIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            errorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 20)
            
            
            
        ])
        
        getJoke()
        
    }
    
    @objc func navigateToSearchView() {
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    @objc func getJoke() {
        self.setError(hasError: false)
        self.setLoadingState(true)
        
        let service = Service()
        
        service.getRandomJoke() {result in
            DispatchQueue.main.async {
                switch result {
                    
                case .failure(_):
                    self.setError(hasError: true)
                    
                case let .success(data):
                    guard let joke = data else {
                        return
                    }
                    
                    self.jokeLabel.text = "\"\(joke.value)\""
                    self.category.text = joke.categories.first ?? "uncategorized"
                    
                }
                
                self.setLoadingState(false)
                
            }
            
        }
        
    }
    func setError(hasError: Bool){
        if hasError {
            
            self.textView.isHidden = true
            self.jokeLabel.isHidden = true
            self.category.isHidden = true
            
            self.errorMessageLabel.isHidden = false
            self.errorButton.isHidden = false
        } else {
            self.textView.isHidden = false
            self.jokeLabel.isHidden = false
            self.category.isHidden = false
            
            self.errorMessageLabel.isHidden = true
            self.errorButton.isHidden = true
        }
    }
    
    func setLoadingState(_ state:Bool) {
        if(state) {
            self.activeIndicator.isHidden = false
            self.textView.isHidden = true
        } else {
            self.activeIndicator.isHidden = true
            self.textView.isHidden = false
        }
    }
    
    
    
}



