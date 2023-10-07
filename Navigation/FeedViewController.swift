//
//  FeedViewController.swift
//  Navigation
//
//  Created by Никита on 16.02.2023.
//
import UIKit

class FeedViewController: UIViewController {
    
    private let newPostTitle = "Latest News"
    //
    private var timer: Timer?
    private var counter = 0
    var timerText: String = ""
    //
    
    let stackView: UIStackView = {
        
        let view = UIStackView()
        view.axis = .vertical // Вертикальное расположение элементов
        view.alignment = .center // Центрирование элементов
        view.distribution = .fillEqually // Правило заполнения стека
        view.spacing = 10 // Отступы между элементами (Подпараметр 17 строки)
        
        return view
    }()

    lazy var button = CustomButton(title: " Go To To ", titleColor: .black, backgroundColor: .green)
    
    // Timer Button
    lazy var timerButton = CustomButton(title: " Start / Stop ", titleColor: .systemYellow, backgroundColor: .blue)

    private func createTimer() {
            timer?.tolerance = 0.3
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self else {return}
            timerLabel.text = "\(counter)"
            counter += 1
        }
    }
    
    func checkValidation() {
        if timer?.isValid ?? false {
            timer?.invalidate()
            timer = nil
        } else {
            createTimer()
        }
    }

    lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.text = "timerLabel"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // Timer Button
    
    private lazy var button2: UIButton = {
        let button = UIButton()
        button.setTitle("Go to post", for: .normal)
        button.backgroundColor = .systemYellow
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 150, height: 40)
        
        return button
    }()
    
    lazy var newTF: UITextField = {
        let textField = UITextField()
        textField.placeholder = " 1111 " //Not forget, placeholder = password
        textField.textColor = .black
        textField.layer.cornerRadius = 10
        textField.font = .systemFont(ofSize: 16)
        textField.backgroundColor = UIColor.systemGray5
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    lazy var checkGuessButton = CustomButton(title: " Check Guess Button ", titleColor: .white, backgroundColor: .black)
    
    lazy var checkLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.text = "Угадай слово"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
#if DEBUG
        view.backgroundColor = .black
#else
        view.backgroundColor = .white
#endif
        setupViews()
        setupConstraints()
        button.delegate = self
        
        // Added CallBack
        checkGuessButton.callBack = { [weak self] in
            let word = self?.newTF.text
            let result = FeedModel().checkSecretWord(word: word ?? "")
            self?.checkLabel.text = result
            if result == "Верно" {
                self?.checkLabel.backgroundColor = .green
            } else {
                self?.checkLabel.backgroundColor = .red
            }
        }
        
        // Added CallBack for Timer
        createTimer()
        timerButton.callBack = {  [weak self] in
            guard let self else {return}
            checkValidation()
            if timer?.isValid == true {
                timerButton.setTitle(" Stop ", for: .normal)
            } else {
                timerButton.setTitle("  Run  ", for: .normal)
            }
        }
        // Timer Button
        
    }


    private func setupViews() {
   //     view.addSubview(button)
        view.addSubview(stackView)
        stackView.addArrangedSubview(timerButton) // Timer Button
        stackView.addArrangedSubview(timerLabel)  // Timer Button
        stackView.addArrangedSubview(button)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(newTF)
        stackView.addArrangedSubview(checkGuessButton)
        stackView.addArrangedSubview(checkLabel)
    }

    private func setupConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }

    @objc private func tapButton() {
        let postViewController = PostViewController()
        postViewController.postTitle = newPostTitle
        navigationController?.pushViewController(postViewController, animated: true)
    }
}


extension FeedViewController: ButtonDelegate {
    func fetchButtonTapped() {
        let postViewController = PostViewController()
        postViewController.postTitle = newPostTitle
        navigationController?.pushViewController(postViewController, animated: true)
    }
}

