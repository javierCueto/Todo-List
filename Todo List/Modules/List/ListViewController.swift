//
//  ListViewController.swift
//  Todo List
//
//  Created by Javier Cueto on 10/04/22.
//

import UIKit
import Combine

final class ListViewController: UITableViewController {
    // MARK: - Private properties
    private var store = Set<AnyCancellable>()
    private lazy var newTodoButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(systemName: Icons.plus)
        configuration.cornerStyle = .capsule
        configuration.buttonSize = .large
        let button = UIButton(configuration: configuration, primaryAction: addNewTodo())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let dataManager: DataManagerCRUD
    private var listTodo = [Todo]()
    // MARK: - Life Cycle
    init(dataManager: DataManagerCRUD) {
        self.dataManager = dataManager
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configTableView()
        listTodo = dataManager.allTodo()
    }
    
    // MARK: - Helpers
    private func configUI() {
        view.backgroundColor = .white
        title = TextValues.titleList
        guard let nav = navigationController else { return }
        
        nav.view.addSubview(newTodoButton)
        newTodoButton.rightAnchor.constraint(
            equalTo: nav.view.rightAnchor,
            constant: -ViewValues.defaultPadding).isActive = true
        
        newTodoButton.bottomAnchor.constraint(
            equalTo: nav.view.bottomAnchor,
            constant: -ViewValues.defaultPadding).isActive = true
        
        nav.navigationBar.prefersLargeTitles = true
    }
    
    private func configTableView() {
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.identifier)
        tableView.separatorStyle = .none
    }
    
    private func reloadData() {
        self.listTodo = self.dataManager.allTodo()
        self.tableView.reloadData()
    }
    
    // MARK: - Actions
    private func addNewTodo() -> UIAction{
        let action = UIAction { _ in
            let controller = TodoViewController()
            
            controller.newTodo.sink { [weak self] todoDescription in
                guard let self = self else { return }
                self.dataManager.saveTodo(description: todoDescription)
                self.reloadData()
            }.store(in: &self.store)
            
            let nav = UINavigationController(rootViewController: controller)
            self.present(nav, animated: true, completion: nil)
        }
        return action
    }
}

extension ListViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListCell.identifier,
                for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        let todo = listTodo[indexPath.section]
        cell.titleLabel.text = todo.title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let todo = listTodo[indexPath.section]
            let id = todo.id?.uuidString ?? TextValues.empty
            dataManager.deleteTodo(uuid: id)
            listTodo.remove(at: indexPath.section)
            
            let indexSet = IndexSet(arrayLiteral: indexPath.section)
            tableView.beginUpdates()
            tableView.deleteSections(indexSet, with: .left)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = listTodo[indexPath.section]
        let uuid = todo.id?.uuidString ?? TextValues.empty
        let controller = TodoViewController(description: todo.title ?? TextValues.empty)
        
        controller.newTodo.sink { [weak self] todoDescription in
            guard let self = self else { return }
            self.dataManager.updateTodo(uuid: uuid, title: todoDescription)
            self.reloadData()
        }.store(in: &self.store)
        
        let nav = UINavigationController(rootViewController: controller)
        self.present(nav, animated: true, completion: nil)
        
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        listTodo.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ViewValues.one
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        ViewValues.defaultPadding
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat(ViewValues.zero)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}
