//
//  SearchViewController.swift
//  Chuck Norris
//
//  Created by Tiago Caldeira Ortiz Lima on 14/02/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    var jokes = [Joke]()
    
    let searchTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBackground
        table.rowHeight = UITableView.automaticDimension
        table.register(JokeTableViewCell.self, forCellReuseIdentifier: JokeTableViewCell.identifier)
        return table
    }()
    
    var activeIndicator : UIActivityIndicatorView = {
        let activeIndicator = UIActivityIndicatorView(style: .large)
        activeIndicator.translatesAutoresizingMaskIntoConstraints = false
        activeIndicator.startAnimating()
        activeIndicator.isHidden = true
        return activeIndicator
    }()
    
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.text = "An error has occurred, please try again."
        label.isHidden = true
        return label
    }()
   
    
    let errorButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Try again", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 25)
        button.addTarget(self, action: #selector(trySearchAgain), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    
    
    
    let searchController = UISearchController(searchResultsController: nil)
    let searchBar = UISearchBar()
    var searchTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Search"
        view.backgroundColor = .systemBackground
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(navigateBack))
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Joke"
        navigationItem.searchController = searchController
        definesPresentationContext = true
                
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchTableView.dataSource = self
        searchTableView.delegate = self
                
        view.addSubview(searchTableView)
        view.addSubview(activeIndicator)
        
        view.addSubview(errorMessageLabel)
        view.addSubview(errorButton)
        
        NSLayoutConstraint.activate([
            
            searchTableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            searchTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activeIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activeIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            errorMessageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorMessageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            errorButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 20)
        ])
        
        
    }
    
    @objc func navigateBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setLoading(isLoading : Bool){
        
        if isLoading {
            searchTableView.isHidden = true
            activeIndicator.isHidden = false
        }else {
            searchTableView.isHidden = false
            activeIndicator.isHidden = true
        }
    }
    
    @objc func trySearchAgain(){
        print("__________________FOI")
        
    }
    
    func setHasError(hasError: Bool){
        if hasError {
            self.searchTableView.isHidden = true
            self.activeIndicator.isHidden = true
            
            self.errorButton.isHidden = false
            self.errorMessageLabel.isHidden = false
        } else {
            self.searchTableView.isHidden = false
            self.activeIndicator.isHidden = false
            
            self.errorButton.isHidden = true
            self.errorMessageLabel.isHidden = true
        }
        
    }
    
    
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.setHasError(hasError: false)
        self.searchTimer?.invalidate()
        
        guard let searchText = searchController.searchBar.text  else {
            self.setLoading(isLoading: false)
            return
        }
        
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.setLoading(isLoading: false)
            return
        }
        
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (timer) in
            self?.setLoading(isLoading: true)
            
            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                
                let service = Service()
                service.searchJoke(query: searchText) { result in
                    switch result {
                    case .failure(_):
                        self?.setHasError(hasError: true)
                        
                    case let .success(data):
                        guard let data = data else {
                            return
                        }
                        
                        
                        DispatchQueue.main.async {
                            self?.jokes = data.result
                            self?.searchTableView.reloadData()
                            self?.setLoading(isLoading: false)
                        }
                    }
                    
                    
                }
                
                
            }
        })
    }
    
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jokes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if jokes.count > 0 {
            tableView.backgroundView = nil
            return jokes.count
        } else {
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text = "No facts found..."
            noDataLabel.textColor = .label
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: JokeTableViewCell.identifier, for: indexPath) as? JokeTableViewCell else {
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        cell.setJoke(joke: jokes[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let items = [URL(string: self.jokes[indexPath.row].url)!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(ac, animated: true)
    }
     
}
