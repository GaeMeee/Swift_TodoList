//
//  WriteTodoViewController.swift
//  chaptedfr
//
//  Created by JeonSangHyeok on 2023/08/08.
//

import UIKit

// 할 일 작성 컨트롤러에 사용할 프로토콜
protocol WriteTodoDelegate: AnyObject {
    func taskCompleted(_ task: Task)
}

// 할 일 작성 및 관리 컨트롤러
class WriteTodoViewController: UIViewController {
    
    weak var delegate: WriteTodoDelegate?
    
    @IBOutlet weak var todoTableView: UITableView!
    
    // "추가" 버튼을 누를 때 호출되는 메서드
    @IBAction func createTodoButton(_ sender: Any) {
        let todoAlert = UIAlertController(title: "할일 작성", message: "추가", preferredStyle: .alert)
        
        todoAlert.addTextField { textField in
            textField.placeholder = "할일 내용"
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] action in
            if let todoText = todoAlert.textFields?.first?.text, !todoText.isEmpty {
                
                let task = Task(todoTitle: todoText, isDone: false, category: .life)
                
                DataManager.shared.addTask(task)
                
                self?.todoTableView.reloadData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        todoAlert.addAction(addAction)
        todoAlert.addAction(cancelAction)
        
        self.present(todoAlert, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.todoTableView.dataSource = self
        self.todoTableView.delegate = self
    }
    
    // 수정 후 todoTableView 리로드
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.todoTableView.reloadData()
    }
}

extension WriteTodoViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 섹션 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return DataManager.shared.categories.count
    }
    
    // Header 이름 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return DataManager.shared.categories[section].rawValue
    }
    
    // Footer 이름 설정
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "\n"
    }
    
    // tableView에 DateManaer.dhared.tasks 배열에 있는 갯수만큼 표시할 행 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let category = DataManager.shared.categories[section]
        let taskInSection = DataManager.shared.filterCategory(category)
        
        return taskInSection.count
    }
    
    // 가지고 있는 카테고리의 값을 맞는 섹션에 반환, 스위치의 값 변경 처리 및 상태 업데이트
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todoTableView.dequeueReusableCell(withIdentifier: "todoCells", for: indexPath) as! TodoListCell
        
        let category = DataManager.shared.categories[indexPath.section]
        let taskForCategory = DataManager.shared.filterCategory(category)
        
        if indexPath.row < taskForCategory.count {
            let task = taskForCategory[indexPath.row]
            cell.todoLabel.text = task.todoTitle
            cell.todoSwitch.isOn = task.isDone
            cell.todoSwitch.tag = indexPath.row
            cell.todoSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            
        } else {
            cell.todoLabel.text = ""
            cell.todoSwitch.isOn = false
            cell.todoSwitch.tag = 0
            cell.todoSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        }
        return cell
    }
    
    // 수정 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editVC.selectedIndex = indexPath.row
        navigationController?.pushViewController(editVC, animated: true)
    }
    
    // 삭제 기능 추가
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { (_, _, completionHandler) in
            
            // 삭제할 할일을 가져옵니다
            let category = DataManager.shared.categories[indexPath.section]
            let taskToDelete = DataManager.shared.filterCategory(category)[indexPath.row]
            
            // 할일 배열에서 할일을 제거합니다
            DataManager.shared.removeTask(taskToDelete)
            
            // 테이블 뷰를 업데이트합니다
            DispatchQueue.main.async {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return configuration
    }
    
    // 스위치 값 변경했을 때 이벤트 처리
    @objc func switchValueChanged(_ sender: UISwitch) {
        let rowIndex = sender.tag
        DataManager.shared.tasks[rowIndex].isDone = sender.isOn
        todoTableView.reloadRows(at: [IndexPath(row: rowIndex, section: 0)], with: .automatic)
        
        if sender.isOn {
            DataManager.shared.completeTask(rowIndex)
            NotificationCenter.default.post(name: .todoCompleted, object: nil)
        }
        
        todoTableView.reloadData()
    }
}

extension Notification.Name {
    static let todoCompleted = Notification.Name("todoCompleted")
}
