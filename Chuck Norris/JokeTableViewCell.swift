//
//  JokeViewCellTableViewCell.swift
//  Chuck Norris
//
//  Created by Tiago Caldeira Ortiz Lima on 14/02/22.
//

import UIKit

class JokeTableViewCell: UITableViewCell {
    
    static let identifier = "JokeTableViewCell"
    
    public var shareJoke: (()-> Void)!
    
    private var containerView : UIView = {
        let container = UIView()
        container.layer.borderWidth = 1
        container.layer.cornerRadius = 10
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private var jokeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    
    private var shareIcon: UIImageView = {
        
        let image = UIImage(systemName: "square.and.arrow.up.circle", withConfiguration: .none)
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        
        return imageView
    }()
    
    private var jokeDebug: Any?
    
    public func setJoke(joke:Joke){
        
        jokeLabel.text = joke.value
        
        if joke.categories.isEmpty {
            let label = JokeCategorieLabel()
            label.text = "uncategorized"
            
            containerView.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor,constant: 10),
                label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
                label.leadingAnchor.constraint(equalTo: jokeLabel.leadingAnchor)
            ])
            
            
        } else {
            var widthUsed = 0.0
            
            for i in 0..<joke.categories.count {
                
                let label = JokeCategorieLabel()
                label.text = joke.categories[i]
                
                containerView.addSubview(label)
                
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: jokeLabel.bottomAnchor,constant: 10),
                    label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
                    label.leadingAnchor.constraint(equalTo: jokeLabel.leadingAnchor, constant: widthUsed)
                ])
                
                widthUsed += label.intrinsicContentSize.width + 8
            }
        }
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(jokeLabel)
        containerView.addSubview(shareIcon)
        
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            
            jokeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            jokeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            jokeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            shareIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            shareIcon.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -10),
            shareIcon.heightAnchor.constraint(equalToConstant: 30),
            shareIcon.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
