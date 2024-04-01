//
//  ProductTableViewCell.swift
//  MoneyBox
//
//  Created by Mark Golubev on 27/03/2024.
//

import UIKit
import Networking

class ProductTableViewCell: UITableViewCell {
    
    public static var identifier: String {
        get {
            return "ProductTableViewCell"
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
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor(.black).cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = K.Design.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let planValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = K.Design.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let moneyboxLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = K.Design.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let selectedImageView: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "checkmark.seal.fill"))
        image.tintColor = UIColor(resource: .accent)
        image.isHidden = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private var vStack: UIStackView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = nil
        planValueLabel.text = nil
        moneyboxLabel.text = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        if selected {
            // Apply selected state UI changes
            selectedImageView.isHidden = false
        } else {
            // Apply deselected state UI changes
            selectedImageView.isHidden = true
        }
    }
    
    // MARK: - Public methods
    func configure(with product: ProductResponse) {
        nameLabel.text = product.product?.name
        planValueLabel.text = "Your plan: \((product.planValue ?? 0.0).toMoneyFormatString())"
        moneyboxLabel.text = "You saved: \((product.moneybox ?? 0.0).toMoneyFormatString())"
    }
}

// MARK: - Setup Cell
private extension ProductTableViewCell {
    func setupCell() {
        backgroundColor = .clear
        
        addSubview()
        setupLayout()
    }
}

// MARK: - Setting
private extension ProductTableViewCell {
    func addSubview() {
        addSubview(view)
        
        vStack = UIStackView(arrangedSubviews: [nameLabel, planValueLabel, moneyboxLabel])
        vStack.axis = .vertical
        vStack.spacing = 5
        vStack.alignment = .leading
        vStack.distribution = .fill
        vStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(vStack)
        view.addSubview(selectedImageView)
    }
}

// MARK: - Setup Layout
private extension ProductTableViewCell {
    func setupLayout() {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
            
            planValueLabel.heightAnchor.constraint(equalToConstant: 20),
            
            moneyboxLabel.heightAnchor.constraint(equalToConstant: 20),
            
            vStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            
            selectedImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            selectedImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            selectedImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
