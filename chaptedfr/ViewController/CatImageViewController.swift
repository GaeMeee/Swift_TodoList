//
//  CatImageViewController.swift
//  chaptedfr
//
//  Created by JeonSangHyeok on 2023/08/30.
//

import UIKit

class CatImageViewController: UIViewController {
    
    @IBOutlet weak var catImage: UIImageView!
    
    // API 주소
    let apiUrl = "https://api.thecatapi.com/v1/images/search"
    
    // placeholder 사용할 이미지
    let placeholderImage = UIImage(systemName: "photo")

    override func viewDidLoad() {
        super.viewDidLoad()

        randomImage()
        
        // 새로고침 버튼 생성 및 randomImage() 메서드 호출
        let reloadImageButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(randomImage))
        
        navigationItem.rightBarButtonItem = reloadImageButton
    }
    
    @objc func randomImage() {
        
        // placeholder 이미지로 초기화하여 로딩 중인 것을 나타냄.
        catImage.image = placeholderImage
        
        guard let url = URL(string: apiUrl) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("데이터 가져오기 오류")
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]], let imageUrlString = jsonArray.first?["url"] as? String, let imageUrl = URL(string: imageUrlString), let imageData = try? Data(contentsOf: imageUrl), let image = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        // 가져온 이미지로 catImage 업데이트
                        self?.catImage.image = image
                    }
                } else {
                    print("이미지 가져오기 오류")
                }
            } catch {
                print("에러")
            }
        }
        // API 요청 시작부분
        task.resume()
    }
}
