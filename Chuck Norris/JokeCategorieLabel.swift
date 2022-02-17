//
//  JokeCategorieLabelView.swift
//  Chuck Norris
//
//  Created by Tiago Caldeira Ortiz Lima on 16/02/22.
//

import UIKit

class JokeCategorieLabel: UILabel {
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height =  originalContentSize.height + 12
        self.layer.cornerRadius = height / 2
        self.layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 16, height:height)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = .boldSystemFont(ofSize: 14)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemOrange
        self.textAlignment = .center
        self.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
