//
//  ListCell.swift
//  Todo List
//
//  Created by Javier Cueto on 10/04/22.
//

import UIKit

final class ListCell: UITableViewCell {
    public static let identifier = String(describing: ListCell.self)
    
    private let colorRandom = RandomColor().color
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = colorRandom
        label.font = UIFont.boldSystemFont(ofSize: ViewValues.defaultSizeText)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configIU()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configIU() {
        addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(
            equalTo: leftAnchor,
            constant: ViewValues.defaultPadding).isActive = true
        
        backgroundColor = colorRandom.withAlphaComponent(ViewValues.opacityBackground)
    }
}
