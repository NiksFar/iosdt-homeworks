//
//  InfoViewController.swift
//  Navigation
//
//  Created by Никита on 20.02.2023.
//

import UIKit

class InfoViewController: UIViewController, UIAlertViewDelegate {
    
    let stringURL = "https://jsonplaceholder.typicode.com/todos/"
    let jsonUrl = "https://swapi.dev/api/planets/1"
    var planetsArray: [Planet] = []
    var objectArray: [InfoObject] = []
    
    lazy var infoLabel: UILabel = {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 24)
            label.textColor = .black
            label.text = "---"
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    lazy var info2Label: UILabel = {
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 24)
            label.textColor = .black
            label.text = "+++"
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
    }()
    
    let planetsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        NetworkService.loadData(urlString: stringURL) { result in
            switch result {
            case .success(let data):
                print(data)
                DispatchQueue.main.async {
                    self.infoLabel.text = NetworkService.jsonObject(with: data)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        NetworkService.loadData(urlString: stringURL) { result in
            switch result {
                
            case .success(let data):
                self.objectArray = NetworkService.parse(jsonData: data, model: InfoObject.self) ?? []
               // self.array = NetworkService.parse(jsonData: data, model: Planet.self) ?? []
             //   print(self.objectArray)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        if let array = NetworkService.loadLocalJson(resource: "File", model: Planet.self) {
            self.planetsArray = array
            DispatchQueue.main.async {
                self.info2Label.text = self.planetsArray[0].orbitalPeriod
                self.planetsTableView.reloadData()
            }
        } else {
            print("NO DATA")
        }
        
    }
    
    private func setupView() {
        setTitle()
        setBackgroundColor()
//        addButton()
        addLabelConstraints()
    }
    
    private func setTitle() {
        title = "Info"
    }
    
    private func setBackgroundColor() {
        view.backgroundColor = UIColor.white
    }
    
    private func addButton() {
        let showAlertButton = UIButton(type: .system)
        showAlertButton.setTitle("Alert", for: .normal)
        showAlertButton.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        view.addSubview(showAlertButton)
        addConstraints(to: showAlertButton)
    }
    
    private func addConstraints(to button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func addLabelConstraints() {
        view.addSubview(infoLabel)
        view.addSubview(info2Label)
        view.addSubview(planetsTableView)
        planetsTableView.translatesAutoresizingMaskIntoConstraints = false
        planetsTableView.backgroundColor = .cyan
        planetsTableView.delegate = self
        planetsTableView.dataSource = self
        NSLayoutConstraint.activate([
            infoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            infoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            info2Label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            info2Label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            planetsTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            planetsTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            planetsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            planetsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }
    
    
    
    
    @objc private func showAlert() {
        let alertController = UIAlertController(title: "Notification", message: "Here is some message", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Choosed Cancel")
        }
        
        let okAction = UIAlertAction(title: "ОК", style: .default) { _ in
            print("Choosed Ok")
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension InfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        planetsArray[0].residents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        //tableView.dequeueReusableCell(withIdentifier: "idiha", for: indexPath)
        let element = planetsArray[0].residents[indexPath.row]
        cell.textLabel?.text = element
        return cell
    }
    
    
}
