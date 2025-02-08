//
//  CharacterListViewController.swift
//  RickAndMorty
//
//  Created by Anton Stogov on 02/02/2025.
//

import UIKit

// MARK: - CharacterListViewController
class CharacterListViewController: UIViewController {
    
    // MARK: - Свойства
    private var collectionView: UICollectionView!
    private var characters: [Character] = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let titleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        view.backgroundColor = UIColor(red: 4/255, green: 12/255, blue: 30/255, alpha: 1.0)
        setupTitleLabel()
        setupCollectionView()
        fetchCharacters()
    }
    
    // MARK: - Настройка навигационной панели
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backButton
    }
    
    // MARK: - Настройка Title Label
    private func setupTitleLabel() {
        titleLabel.text = "Character"
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        view.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        // Количество столбцов
        let screenWidth = UIScreen.main.bounds.width
        let spacing: CGFloat = 16  // Отступ между элементами по горизонтали и вертикали
        
        // Доступная ширина для ячеек (ширина экрана минус отступы между колонками)
        let availableWidth = screenWidth - (spacing * 3)  // 1 отступ с каждой стороны и 1 между столбцами
        let itemWidth = availableWidth / 2  // Для двух столбцов
        
        // Настройка размера ячеек и отступов
        layout.itemSize = CGSize(width: itemWidth, height: 202)
        layout.minimumInteritemSpacing = spacing  // Отступ между элементами по горизонтали
        layout.minimumLineSpacing = spacing       // Отступ между элементами по вертикали
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)  // Отступы секции
        
        // Настройка collection view
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: "CharacterCell")
        view.addSubview(collectionView)
        
        // Настройка индикатора активности
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    
    // MARK: - Работа с сетью
    private func fetchCharacters() {
        activityIndicator.startAnimating()
        NetworkService.shared.getCharacters { [weak self] characters in
            self?.characters = characters
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension CharacterListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    // Настрайка ячейки для отображения информации о персонаже
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath) as! CharacterCell
        let character = characters[indexPath.row]
        cell.configure(with: character)
        return cell
    }
    
    // Переход к экрану деталей персонажа
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characters[indexPath.row]
        let detailVC = CharacterDetailViewController()
        detailVC.character = character
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
