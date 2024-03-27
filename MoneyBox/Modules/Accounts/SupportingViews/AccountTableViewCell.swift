//
//  AccountTableViewCell.swift
//  MoneyBox
//
//  Created by Mark Golubev on 26/03/2024.
//

import UIKit
import Networking

class AccountTableViewCell: UITableViewCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    public static var identifier: String {
        get {
            return "AccountTableViewCell"
        }
    }
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    private let view: UIView = {
        let view = UIView()
        view.backgroundColor = K.Design.secondaryCellColor
//        view.layer.cornerRadius = 5
//        view.layer.shadowColor = K.Design.separatorLineColor?.cgColor
//        view.layer.shadowOpacity = 1
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = K.Design.secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = K.Design.secondaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        image.tintColor = K.Design.secondaryColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var hStack: UIStackView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text          = nil
        amountLabel.text        = nil

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor         = .clear
    }
    
    // MARK: - Public methods
    func configure(with item: Account) {
        nameLabel.text          = item.name
        amountLabel.text        = "£\(item.wrapper?.totalValue ?? 0.00)"
    }
}

// MARK: - Setup Cell
private extension AccountTableViewCell {
    func setupCell() {
        backgroundColor = .clear
        
        addSubview()
        setupLayout()
    }
}

// MARK: - Setting
private extension AccountTableViewCell {
    func addSubview() {
        addSubview(view)
        
        hStack = UIStackView(arrangedSubviews: [nameLabel, amountLabel, arrowImageView])
        hStack.axis = .horizontal
        hStack.spacing = 10
        hStack.alignment = .leading
        hStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(hStack)
    }
}

// MARK: - Setup Layout
private extension AccountTableViewCell {
    func setupLayout() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            amountLabel.heightAnchor.constraint(equalToConstant: 20),
            
            arrowImageView.heightAnchor.constraint(equalToConstant: 20),
            
            hStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            hStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        ])
    }
}

