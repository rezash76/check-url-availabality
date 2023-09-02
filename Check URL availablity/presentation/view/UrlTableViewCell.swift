//
//  URLTableViewCell.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import UIKit

class UrlTableViewCell: UITableViewCell {
    
    lazy var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    lazy var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.startAnimating()
        return loading
    }()
    
    lazy var urlLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var checkingTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Properties
    
    public var urlModel: UrlModel! {
        didSet {
            if urlModel.isChecking {
                iconImage.isHidden = true
                loading.isHidden = false
                loading.startAnimating()
            } else {
                iconImage.isHidden = false
                loading.isHidden = true
                self.iconImage.image = UIImage(systemName: urlModel.isAvailable ? "checkmark.circle.fill" : "multiply.circle.fill")
                self.iconImage.tintColor = urlModel.isAvailable ? .systemGreen : .systemRed
            }
            
            self.urlLabel.text = urlModel.url
            self.checkingTimeLabel.text = urlModel.checkingTime == 0 ? "-" : "\(urlModel.checkingTime) '"
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        addViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func addViews() {
        contentView.addSubview(iconImage)
        contentView.addSubview(urlLabel)
        contentView.addSubview(loading)
        contentView.addSubview(checkingTimeLabel)
    }
    
    func constraintViews() {
        
        
        if (urlModel?.isChecking ?? false) {
            NSLayoutConstraint.activate([
                loading.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                loading.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                loading.heightAnchor.constraint(equalToConstant: 30),
                loading.widthAnchor.constraint(equalTo: loading.heightAnchor),
                
                urlLabel.leadingAnchor.constraint(equalTo: loading.trailingAnchor, constant: 8),
//                urlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                urlLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                urlLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
                urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                
                checkingTimeLabel.leadingAnchor.constraint(equalTo: urlLabel.trailingAnchor, constant: 8),
                checkingTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                checkingTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                checkingTimeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
                checkingTimeLabel.widthAnchor.constraint(equalToConstant: 80),
                checkingTimeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                iconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                iconImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                iconImage.heightAnchor.constraint(equalToConstant: 30),
                iconImage.widthAnchor.constraint(equalTo: iconImage.heightAnchor),
                
                urlLabel.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 8),
//                urlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                urlLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                urlLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
                urlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                
                checkingTimeLabel.leadingAnchor.constraint(equalTo: urlLabel.trailingAnchor, constant: 8),
                checkingTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                checkingTimeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                checkingTimeLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 40),
                checkingTimeLabel.widthAnchor.constraint(equalToConstant: 80),
                checkingTimeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    }
}
