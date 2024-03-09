//
//  BreedImageCollectionViewCell.swift
//  Find Your Dog
//
//  Created by Aditya Vyavahare on 09/03/24.
//

import UIKit

class BreedImageCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let likeButton = UIButton(type: .custom)
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupLikeButton()
        setupTitlelabel()
        
        if UserDefaults.standard.bool(forKey: "ShouldShowTitle") {
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                likeButton.widthAnchor.constraint(equalToConstant: 30),
                likeButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        } else {
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                likeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
                likeButton.widthAnchor.constraint(equalToConstant: 30),
                likeButton.heightAnchor.constraint(equalToConstant: 30)
            ])
        }
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
    }
    
    func setupLikeButton() {
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        likeButton.tintColor = .red
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likeButton)
    }
    
    func setupTitlelabel() {
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
