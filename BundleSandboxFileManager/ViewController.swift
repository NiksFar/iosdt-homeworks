//
//  ViewController.swift
//  BundleSandboxFileManager
//
//  Created by Никита on 13.11.2023.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var addImage = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addImageAction))
    lazy var addFolder = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(addFolderAction))
    lazy var backButton = UIBarButtonItem(title: nil, style: .plain, target: self, action: #selector(backButtonAction))
    
    var tableView = UITableView()
    let picker = UIImagePickerController()
    
    var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    var contents: [String]?
    
    var currentPaths: [String] = []
    var currentFolder: String = "Documents"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        picker.delegate = self
        view.backgroundColor = .yellow
        navigationItem.rightBarButtonItems = [addImage, addFolder]
        navigationItem.leftBarButtonItem = backButton
        setupView()
        contents = try? FileManager.default.contentsOfDirectory(atPath: paths[0])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
    }
    
    private func setupView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
    }
    
    func alertTextField(message: String?, completion: @escaping(_ result: Bool, _ text: String?) -> Void) {
        let alert = UIAlertController(title: "Create Folder", message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Folder Name"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            completion(false, nil)
        }))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            completion(true, alert.textFields?.first?.text)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getCurrentPath() -> String {
        var path = ""
        guard !currentPaths.isEmpty else {return path}
        for name in currentPaths {
            path += "/\(name)"
        }
        print(path)
        return path
    }
    
    @objc func addImageAction() {
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true)

    }

    @objc func addFolderAction() {
        alertTextField(message: nil) { result, text in
            if result, let text = text {
                FileService.shared.createDirectory(name: self.getCurrentPath() + "/\(text)")
                self.contents = try? FileManager.default.contentsOfDirectory(atPath: self.paths[0] + self.getCurrentPath())
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @objc func backButtonAction() {
        currentPaths.removeLast()
        self.contents = try? FileManager.default.contentsOfDirectory(atPath: self.paths[0] + self.getCurrentPath())
        print(currentPaths)
        if currentPaths.isEmpty {
            currentFolder = "Documents"
            backButton.title = nil
        } else {
            currentFolder = currentPaths.last!
            if currentPaths.count > 1 {
                backButton.title = "< " + currentPaths[currentPaths.count - 2]
            } else {
                backButton.title = "< Document"
            }
        }
        tableView.reloadData()
    }
                                        
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contents?.count ?? 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentFolder
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let name = contents?[indexPath.row] else { return }
            
            let documentsDirectoryURL = try! FileManager().url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fullName = getCurrentPath() + "/\(name)"
            let fileURL = documentsDirectoryURL.appendingPathComponent(fullName)
            let deletedPath = fileURL.path
            FileService.shared.removeContent(path: deletedPath)
            //print(contents?[indexPath.row])
            self.contents = try? FileManager.default.contentsOfDirectory(atPath: self.paths[0] + getCurrentPath())
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        guard let name = contents?[indexPath.row] else {return UITableViewCell()}
        cell.textLabel?.text = name
        let fullName = getCurrentPath() + "/\(name)"
        print(fullName)
        if let isFile = FileService.shared.checkFile(name: fullName) {
            cell.accessoryType = isFile ? .none : .disclosureIndicator
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = tableView.cellForRow(at: indexPath)?.accessoryType
        if type == .disclosureIndicator {
            print("Folder")
            guard let name = contents?[indexPath.row] else {return}
            currentPaths.append(name)
            self.contents = try? FileManager.default.contentsOfDirectory(atPath: self.paths[0] + "/\(name)")
            backButton.title = "﹤ \(currentFolder)"
            currentFolder = name
            tableView.reloadData()
        } else {
            print("File")
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imgUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                let imageName = imgUrl.lastPathComponent
                let fullName = getCurrentPath() + "/\(imageName)"
                FileService.shared.createFile(image: pickedImage, name: fullName) { result in
                    if result {
                        print("reload")
                        self.contents = try? FileManager.default.contentsOfDirectory(atPath: self.paths[0] + self.getCurrentPath())
                        self.tableView.reloadData()
                    }
                }
            }
        }
        self.dismiss(animated: false)
    }
}
