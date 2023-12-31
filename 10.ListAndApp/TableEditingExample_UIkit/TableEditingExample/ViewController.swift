//
//  ViewController.swift
//  MovieListQuiz
//
//  Created by MRF on 2021/07/01.
//

import UIKit

class ViewController: UIViewController {
    
    var data = ["a", "b", "c", "d", "e", "f", "g", "h"]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func handleAdd(_ sender: Any) {
        let alert = UIAlertController(title: "추가하기", message: nil, preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            guard
                let textFields = alert.textFields, textFields.count > 0,
                let userInput = textFields[0].text, userInput.count > 0 else {
                return
            }
            
            print("userInput :", userInput)
            
            let indexPath = IndexPath(row: self.data.count, section: 0)
            self.data.append(userInput)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }))
        self.present(alert, animated: true)
    }
    
    
    @IBAction func handleEdit(_ sender: UIBarButtonItem) {
        tableView.setEditing(!tableView.isEditing, animated: true)
        sender.title = tableView.isEditing ? "Done" : "Edit"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        
        let item = data[indexPath.row]
        cell.textLabel?.text = item
        return cell
    }
        
    // 셀 내 추가/삭제 컨트롤 이벤트 발생시
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // 셀 삭제시
        // 1. 데이터 삭제
        // 2. 뷰에 반영. reloadData의 경우 애니메이션 효과가 없다.
        data.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // 셀 드래그로 이동. 셀은 사용자 이벤트로 이동된 상태이므로, 데이터만 이동하면 됨
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 삭제 후 새로운 위치에 추가
//        let item = data.remove(at: sourceIndexPath.row)
//        data.insert(item, at: destinationIndexPath.row)
        
        // move하기. iOS13 이후, sourceIndex가 빠진 상태로 toOffset을 계산해야 함.
        let toOffset = destinationIndexPath.row + (sourceIndexPath < destinationIndexPath ? 1 : 0)
        data.move(fromOffsets: IndexSet(integer: sourceIndexPath.row), toOffset: toOffset )
        print("after move :", data)
    }
}
