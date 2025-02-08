//
//  CharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Anton Stogov on 02/02/2025.
//

import UIKit

// MARK: - Модель эпизода
struct Episode: Decodable {
    let id: Int
    let name: String
    let episode: String
    let air_date: String
}

// MARK: - Контроллер деталей персонажа
class CharacterDetailViewController: UIViewController {
    
    // MARK: - Свойства
    var character: Character?
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let statusLabel = UILabel()
    private let infoTitleLabel = UILabel()
    private let infoBackgroundView = UIView()
    private let speciesLabel = UILabel()
    private let speciesValueLabel = UILabel()
    private let genderLabel = UILabel()
    private let genderValueLabel = UILabel()
    private let typeLabel = UILabel()
    private let typeValueLabel = UILabel()
    private let originTitleLabel = UILabel()
    private let originBackgroundView = UIView()
    private let originPlanetImageView = UIImageView()
    private let originNameLabel = UILabel()
    private let episodesTitleLabel = UILabel()
    private let episodesBackgroundView = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar прозрачный
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        // Устанавливаем цвет текста и кнопок на белый
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        // Настройка фона ViewController
        view.backgroundColor = UIColor(red: 4/255, green: 12/255, blue: 30/255, alpha: 1.0)
        
        setupViews()
        fetchCharacterDetail()
    }
    
    // MARK: - Методы настройки
    private func setupViews() {
        configureScrollView()
        configureMainContent()
        configureInfoSection()
        configureOriginSection()
        configureEpisodesSection()
        configureActivityIndicator()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    
    private func configureMainContent() {
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(statusLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Например, ширина изображения составит 40% от ширины contentView, а высота будет равна ширине (сохраняя пропорции)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            statusLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            statusLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
        
        imageView.layer.cornerRadius = 15
        imageView.clipsToBounds = true
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        statusLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        statusLabel.textColor = UIColor(red: 71/255, green: 198/255, blue: 11/255, alpha: 1.0)
        statusLabel.textAlignment = .center
    }
    
    private func configureInfoSection() {
        contentView.addSubview(infoTitleLabel)
        contentView.addSubview(infoBackgroundView)
        
        infoTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            infoTitleLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 16),
            infoTitleLabel.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            infoTitleLabel.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            
            infoBackgroundView.topAnchor.constraint(equalTo: infoTitleLabel.bottomAnchor, constant: 8),
            infoBackgroundView.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            infoBackgroundView.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor)
        ])
        
        infoTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        infoTitleLabel.textColor = .white
        infoTitleLabel.text = "Info"
        
        infoBackgroundView.layer.cornerRadius = 10
        infoBackgroundView.backgroundColor = UIColor(red: 38/255, green: 42/255, blue: 56/255, alpha: 1.0)
        
        configureInfoLabels()
    }
    
    private func configureInfoLabels() {
        let labels = [
            (speciesLabel, speciesValueLabel),
            (genderLabel, genderValueLabel),
            (typeLabel, typeValueLabel)
        ]
        
        var previousLabel: UILabel?
        
        for (titleLabel, valueLabel) in labels {
            infoBackgroundView.addSubview(titleLabel)
            infoBackgroundView.addSubview(valueLabel)
            
            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            valueLabel.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                titleLabel.leadingAnchor.constraint(equalTo: infoBackgroundView.leadingAnchor, constant: 8),
                valueLabel.trailingAnchor.constraint(equalTo: infoBackgroundView.trailingAnchor, constant: -8),
                titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -8),
                valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
            ])
            
            if let previous = previousLabel {
                titleLabel.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 8).isActive = true
            } else {
                titleLabel.topAnchor.constraint(equalTo: infoBackgroundView.topAnchor, constant: 8).isActive = true
            }
            
            titleLabel.font = UIFont.systemFont(ofSize: 16)
            titleLabel.textColor = .white
            
            valueLabel.font = UIFont.boldSystemFont(ofSize: 16)
            valueLabel.textColor = .white
            valueLabel.textAlignment = .right
            
            previousLabel = titleLabel
        }
        
        typeValueLabel.bottomAnchor.constraint(equalTo: infoBackgroundView.bottomAnchor, constant: -8).isActive = true
    }
    
    private func configureOriginSection() {
        contentView.addSubview(originTitleLabel)
        contentView.addSubview(originBackgroundView)
        originBackgroundView.addSubview(originPlanetImageView)
        
        // Добавляем новый UILabel для индекса планеты
        let planetIndexLabel = UILabel()
        originBackgroundView.addSubview(planetIndexLabel)
        
        originTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        originBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        originPlanetImageView.translatesAutoresizingMaskIntoConstraints = false
        planetIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            originTitleLabel.topAnchor.constraint(equalTo: infoBackgroundView.bottomAnchor, constant: 16),
            originTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            originTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            originBackgroundView.topAnchor.constraint(equalTo: originTitleLabel.bottomAnchor, constant: 8),
            originBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            originBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            originPlanetImageView.widthAnchor.constraint(equalToConstant: 64),
            originPlanetImageView.heightAnchor.constraint(equalToConstant: 64),
            originPlanetImageView.leadingAnchor.constraint(equalTo: originBackgroundView.leadingAnchor, constant: 8),
            originPlanetImageView.topAnchor.constraint(equalTo: originBackgroundView.topAnchor, constant: 8),
            originPlanetImageView.bottomAnchor.constraint(equalTo: originBackgroundView.bottomAnchor, constant: -8),
            
            // Констрейнты для planetIndexLabel
            planetIndexLabel.leadingAnchor.constraint(equalTo: originPlanetImageView.trailingAnchor, constant: 8),
            planetIndexLabel.trailingAnchor.constraint(equalTo: originBackgroundView.trailingAnchor, constant: -8),
            planetIndexLabel.bottomAnchor.constraint(equalTo: originPlanetImageView.bottomAnchor, constant: -8)
        ])
        
        originTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        originTitleLabel.textColor = .white
        originTitleLabel.text = "Origin"
        
        originBackgroundView.layer.cornerRadius = 10
        originBackgroundView.backgroundColor = UIColor(red: 38/255, green: 42/255, blue: 56/255, alpha: 1.0)
        
        originPlanetImageView.layer.cornerRadius = 5
        originPlanetImageView.clipsToBounds = true
        originPlanetImageView.contentMode = .scaleAspectFill
        originPlanetImageView.backgroundColor = UIColor(red: 25/255, green: 28/255, blue: 42/255, alpha: 1.0)
        
        // Настройка planetIndexLabel
        planetIndexLabel.text = "Planet" // Текст индекса планеты
        planetIndexLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        planetIndexLabel.textColor = UIColor(red: 71/255, green: 198/255, blue: 11/255, alpha: 1.0) // Зеленый цвет #47C60B
        
        // Настройка originNameLabel (название планеты)
        originNameLabel.text = "Earth" // Пример названия планеты
        originNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        originNameLabel.textColor = .white
        originNameLabel.numberOfLines = 0
        
        // Добавляем originNameLabel в originBackgroundView
        originBackgroundView.addSubview(originNameLabel)
        originNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            originNameLabel.leadingAnchor.constraint(equalTo: originPlanetImageView.trailingAnchor, constant: 8),
            originNameLabel.trailingAnchor.constraint(equalTo: originBackgroundView.trailingAnchor, constant: -8),
            originNameLabel.topAnchor.constraint(equalTo: originPlanetImageView.topAnchor, constant: 8),
            originNameLabel.bottomAnchor.constraint(equalTo: planetIndexLabel.topAnchor, constant: -4)
        ])
        
        // Создаем контейнер для иконки планеты
        let planetIconContainer = UIView()
        let planetIconImageView = UIImageView()
        
        // Добавляем элементы
        originBackgroundView.addSubview(planetIconContainer)
        planetIconContainer.addSubview(planetIconImageView)
        originBackgroundView.addSubview(originNameLabel)
        originBackgroundView.addSubview(planetIndexLabel)
        
        // Настройка контейнера для иконки
        planetIconContainer.translatesAutoresizingMaskIntoConstraints = false
        planetIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Контейнер для иконки 64x64
            planetIconContainer.widthAnchor.constraint(equalToConstant: 64),
            planetIconContainer.heightAnchor.constraint(equalToConstant: 64),
            planetIconContainer.leadingAnchor.constraint(equalTo: originBackgroundView.leadingAnchor, constant: 8),
            planetIconContainer.centerYAnchor.constraint(equalTo: originBackgroundView.centerYAnchor),
            
            // Сама иконка 24x24 по центру контейнера
            planetIconImageView.widthAnchor.constraint(equalToConstant: 24),
            planetIconImageView.heightAnchor.constraint(equalToConstant: 24),
            planetIconImageView.centerXAnchor.constraint(equalTo: planetIconContainer.centerXAnchor),
            planetIconImageView.centerYAnchor.constraint(equalTo: planetIconContainer.centerYAnchor)
        ])
        
        // Остальные констрейнты и настройки
        planetIconContainer.layer.cornerRadius = 5
        planetIconContainer.clipsToBounds = true
        planetIconContainer.backgroundColor = UIColor(red: 25/255, green: 28/255, blue: 42/255, alpha: 1.0)
        
        planetIconImageView.contentMode = .scaleAspectFit
        planetIconImageView.image = UIImage(named: "planet_ram")
    }
    
    private func configureEpisodesSection() {
        contentView.addSubview(episodesTitleLabel)
        contentView.addSubview(episodesBackgroundView)
        
        episodesTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        episodesBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            episodesTitleLabel.topAnchor.constraint(equalTo: originBackgroundView.bottomAnchor, constant: 16),
            episodesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            episodesTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            episodesBackgroundView.topAnchor.constraint(equalTo: episodesTitleLabel.bottomAnchor, constant: 8),
            episodesBackgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            episodesBackgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            episodesBackgroundView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
        
        episodesTitleLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        episodesTitleLabel.textColor = .white
        episodesTitleLabel.text = "Episodes"
        
        episodesBackgroundView.layer.cornerRadius = 10
        episodesBackgroundView.backgroundColor = UIColor(red: 38/255, green: 42/255, blue: 56/255, alpha: 1.0)
    }
    
    private func configureActivityIndicator() {
        contentView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Сетевые запросы
    private func fetchCharacterDetail() {
        guard let character = character else { return }
        activityIndicator.startAnimating()
        
        NetworkService.shared.getCharacterDetail(id: character.id) { [weak self] characterDetail in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.configureCharacterDetails(characterDetail)
                self?.loadEpisodes(from: characterDetail.episode)
            }
        }
    }
    
    // MARK: - Конфигурация данных
    private func configureCharacterDetails(_ detail: CharacterDetail) {
        nameLabel.text = detail.name
        statusLabel.text = detail.status
        speciesLabel.text = "Species:"
        speciesValueLabel.text = detail.species
        genderLabel.text = "Gender:"
        genderValueLabel.text = detail.gender
        typeLabel.text = "Type:"
        typeValueLabel.text = detail.type?.isEmpty == false ? detail.type! : "None"
        originNameLabel.text = detail.origin.name
        loadImage(from: detail.image)
    }
    
    private func loadEpisodes(from urls: [String]) {
        var episodes: [Episode] = []
        let group = DispatchGroup()
        
        for urlString in urls {
            guard let url = URL(string: urlString) else { continue }
            group.enter()
            
            URLSession.shared.dataTask(with: url) { data, _, _ in
                defer { group.leave() }
                if let data = data, let episode = try? JSONDecoder().decode(Episode.self, from: data) {
                    episodes.append(episode)
                }
            }.resume()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.displayEpisodes(episodes.sorted { $0.id < $1.id })
        }
    }
    
    private func displayEpisodes(_ episodes: [Episode]) {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        
        episodes.forEach { episode in
            let episodeContainer = UIView()
            episodeContainer.backgroundColor = UIColor(red: 25/255, green: 28/255, blue: 42/255, alpha: 1.0)
            episodeContainer.layer.cornerRadius = 10
            
            let episodeView = EpisodeView()
            episodeView.configure(with: episode)
            
            episodeContainer.addSubview(episodeView)
            episodeView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                episodeView.topAnchor.constraint(equalTo: episodeContainer.topAnchor, constant: 12),
                episodeView.leadingAnchor.constraint(equalTo: episodeContainer.leadingAnchor, constant: 12),
                episodeView.trailingAnchor.constraint(equalTo: episodeContainer.trailingAnchor, constant: -12),
                episodeView.bottomAnchor.constraint(equalTo: episodeContainer.bottomAnchor, constant: -12)
            ])
            
            stackView.addArrangedSubview(episodeContainer)
        }
        
        episodesBackgroundView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: episodesBackgroundView.topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: episodesBackgroundView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: episodesBackgroundView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: episodesBackgroundView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - Вспомогательные методы
    private func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }
}

// MARK: - Вид эпизода
class EpisodeView: UIView {
    
    // MARK: - Свойства
    private let nameLabel = UILabel()
    private let episodeLabel = UILabel() // Номер серии и сезона
    private let dateLabel = UILabel()    // Дата выхода
    
    // MARK: - Инициализация
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) не реализован")
    }
    
    // MARK: - Приватные методы
    private func parseEpisodeInfo(_ episodeCode: String) -> (season: Int, episode: Int)? {
        let pattern = "S(\\d+)E(\\d+)"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: episodeCode, range: NSRange(episodeCode.startIndex..., in: episodeCode)),
              match.numberOfRanges == 3 else {
            return nil
        }
        
        let seasonRange = Range(match.range(at: 1), in: episodeCode)!
        let episodeRange = Range(match.range(at: 2), in: episodeCode)!
        
        let seasonString = String(episodeCode[seasonRange])
        let episodeString = String(episodeCode[episodeRange])
        
        return (Int(seasonString)!, Int(episodeString)!)
    }
    
    private func setupViews() {
        // Настройка nameLabel
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        nameLabel.textColor = .white
        
        // Настройка episodeLabel
        episodeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        episodeLabel.textColor = UIColor(red: 71/255, green: 198/255, blue: 11/255, alpha: 1.0) // Зеленый цвет #47C60B
        
        // Настройка dateLabel
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        dateLabel.textColor = UIColor(red: 147/255, green: 152/255, blue: 156/255, alpha: 1.0) // Серый цвет #93989C
        
        // Горизонтальный стек для episodeLabel и dateLabel
        let infoStackView = UIStackView(arrangedSubviews: [episodeLabel, dateLabel])
        infoStackView.axis = .horizontal
        infoStackView.spacing = 8
        infoStackView.distribution = .fill
        
        // Вертикальный стек для nameLabel и infoStackView
        let mainStackView = UIStackView(arrangedSubviews: [nameLabel, infoStackView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 4
        
        // Добавляем mainStackView на экран
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Конфигурация
    func configure(with episode: Episode) {
        nameLabel.text = episode.name
        dateLabel.text = episode.air_date
        
        if let info = parseEpisodeInfo(episode.episode) {
            episodeLabel.text = "Episode: \(info.episode), Season: \(info.season)"
        } else {
            episodeLabel.text = "Unknown episode info"
        }
    }
}

// MARK: - Сетевые модели
struct CharacterOrigin: Decodable {
    let name: String
}

struct CharacterDetail: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let type: String?
    let origin: CharacterOrigin
    let episode: [String]
    let image: String
}

// MARK: - Расширение NetworkService
extension NetworkService {
    func getCharacterDetail(id: Int, completion: @escaping (CharacterDetail) -> Void) {
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/\(id)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            do {
                let detail = try JSONDecoder().decode(CharacterDetail.self, from: data)
                DispatchQueue.main.async { completion(detail) }
            } catch {
                print("Ошибка декодирования: \(error)")
            }
        }.resume()
    }
}
