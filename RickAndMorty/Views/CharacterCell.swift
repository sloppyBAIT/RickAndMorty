//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Anton Stogov on 02/02/2025.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let background = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        background.layer.cornerRadius = 15
        background.clipsToBounds = true
        background.backgroundColor = UIColor(red: 38/255, green: 42/255, blue: 56/255, alpha: 1.0) // Цвет подложки
        contentView.addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        background.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 140),
            imageView.heightAnchor.constraint(equalToConstant: 140),
            imageView.topAnchor.constraint(equalTo: background.topAnchor, constant: 8),
            imageView.centerXAnchor.constraint(equalTo: background.centerXAnchor),
        ])
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.textColor = .white // Цвет текста
        nameLabel.textAlignment = .center
        background.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15), // Увеличиваем отступ
            nameLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 4),
            nameLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -4)
        ])
    }
    
    func configure(with character: Character) {
        nameLabel.text = character.name
        loadImage(from: character.image)
    }
    
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }.resume()
    }
}
