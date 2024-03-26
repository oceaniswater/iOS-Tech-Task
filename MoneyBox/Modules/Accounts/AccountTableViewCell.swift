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
        view.backgroundColor = K.Design.primaryCellColor
        view.layer.cornerRadius = 5
//        view.layer.shadowColor = K.Design.separatorLineColor?.cgColor
//        view.layer.shadowOpacity = 1
//        view.layer.shadowOffset = CGSize(width: 0, height: 2)
//        view.layer.shadowRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = K.Design.primaryTextColor
        return label
    }()
    
    private let planLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = K.Design.primaryTextColor
        return label
    }()
    
    private let moneyboxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = K.Design.primaryTextColor
        return label
    }()
    
    private var vStack: UIStackView!
    private var hStack: UIStackView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text      = nil
        planLabel.text      = nil
        moneyboxLabel.text  = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    
    // MARK: - Public methods
    func configure(with item: ProductResponse) {
        nameLabel.text          = item.product?.name
        planLabel.text          = "Plan Value: \(item.planValue ?? 0.00)"
        moneyboxLabel.text      = "Moneybox: \(item.moneybox ?? 0.00)"
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
        
        vStack = UIStackView(arrangedSubviews: [nameLabel, planLabel, moneyboxLabel])
        vStack.axis = .vertical
        vStack.spacing = 5
        vStack.alignment = .leading
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(vStack)
    }
}

// MARK: - Setup Layout
private extension AccountTableViewCell {
    func setupLayout() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            view.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            planLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            planLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            planLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            planLabel.heightAnchor.constraint(equalToConstant: 20),
            
            moneyboxLabel.topAnchor.constraint(equalTo: planLabel.bottomAnchor, constant: 4),
            moneyboxLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            moneyboxLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            moneyboxLabel.heightAnchor.constraint(equalToConstant: 20),
            
            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8)
        ])
    }
}

