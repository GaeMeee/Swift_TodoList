//
//  EditViewController.swift
//  chaptedfr
//
//  Created by JeonSangHyeok on 2023/08/30.
//

import UIKit

class EditViewController: UIViewController {
    
    var selectedIndex: Int?
    
    @IBOutlet weak var editTextField: UITextField!
    
    @IBOutlet weak var selectCategory: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let index = selectedIndex {
            let selectedTask = DataManager.shared.tasks[index]
            editTextField.text = selectedTask.todoTitle
            selectCategory.selectedSegmentIndex = selectedTask.category.rawValue == "life" ? 0 : (selectedTask.category.rawValue == "work" ? 1 : 2)
        }
        
        // 수정 버튼 생성
        let editButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonTap))
        
        navigationItem.rightBarButtonItem = editButton
    }
    
    // 수정 버튼 기능 메서드
    @objc func saveButtonTap() {
        if let index = selectedIndex, let editedText = editTextField.text, !editedText.isEmpty {
            
            var editedCategory: Category = .life
            
            switch selectCategory.selectedSegmentIndex {
            case 0:
                editedCategory = .life
            case 1:
                editedCategory = .work
            case 2:
                editedCategory = .travel
            default:
                break
            }
            
            DataManager.shared.editTask(at: index, newTitle: editedText, newCategory: editedCategory)
            
            navigationController?.popViewController(animated: true)
        }
    }
}
