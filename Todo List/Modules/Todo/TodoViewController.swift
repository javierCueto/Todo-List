//
//  TodoViewController.swift
//  Todo List
//
//  Created by Javier Cueto on 10/04/22.
//

import UIKit
import Combine

final class TodoViewController: UIViewController {
    
    // MARK: - Private properties
    private let descriptionTask: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .tertiarySystemBackground
        textField.layer.cornerRadius = ViewValues.defaultRadius
        textField.leftView = UIView(frame: .init(
            x: ViewValues.zero,
            y: ViewValues.zero,
            width: Int(ViewValues.defaultPadding),
            height: ViewValues.zero))
        
        textField.leftViewMode = .always
        textField.placeholder = TextValues.descriptionPlaceHolder
        textField.font = UIFont.boldSystemFont(ofSize: ViewValues.defaultSizeText)
        textField.returnKeyType = .done
        return textField
    }()
    
    private lazy var saveEditButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.cornerStyle = .large
        var container = AttributeContainer()
        container.font = UIFont.boldSystemFont(ofSize: ViewValues.defaultSizeText)
        configuration.attributedTitle = AttributedString(TextValues.saveButton, attributes: container)
        let button = UIButton(configuration: configuration, primaryAction: saveTodoAction())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let newTodo = PassthroughSubject<String, Never>()
    
    init(description: String = TextValues.empty) {
        descriptionTask.text = description
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configIUI()
    }
    
    // MARK: - Helpers
    private func configIUI() {
        view.backgroundColor = .systemGroupedBackground
        title = TextValues.titleNewTodo
        
        view.addSubview(descriptionTask)
        descriptionTask.leftAnchor.constraint(
            equalTo: view.leftAnchor,
            constant: ViewValues.defaultPadding).isActive = true
        
        descriptionTask.rightAnchor.constraint(
            equalTo: view.rightAnchor,
            constant: -ViewValues.defaultPadding).isActive = true
        
        descriptionTask.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: ViewValues.topPadding).isActive = true
        
        descriptionTask.heightAnchor.constraint(equalToConstant: ViewValues.defaultHeight).isActive = true
        
        view.addSubview(saveEditButton)
        saveEditButton.leftAnchor.constraint(
            equalTo: view.leftAnchor,
            constant: ViewValues.defaultPadding).isActive = true
        
        saveEditButton.rightAnchor.constraint(
            equalTo: view.rightAnchor,
            constant: -ViewValues.defaultPadding).isActive = true
        
        saveEditButton.topAnchor.constraint(
            equalTo: descriptionTask.bottomAnchor,
            constant: ViewValues.defaultPadding).isActive = true
        
        saveEditButton.heightAnchor.constraint(equalToConstant: ViewValues.defaultHeight).isActive = true
        
        descriptionTask.becomeFirstResponder()
        descriptionTask.delegate = self
    }
    
    // MARK: - Actions
    private func saveTodoAction() -> UIAction {
        let action = UIAction { [weak self] _ in
            guard let self = self else { return }
            self.saveTodo()
        }
        return action
    }
    
    private func saveTodo() {
        guard let safeText = descriptionTask.text, safeText != TextValues.empty else { return }
        newTodo.send(safeText)
        dismiss(animated: true, completion: nil)
    }

}

extension TodoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTodo()
        return true
    }
}
