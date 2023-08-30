//
//  ViewController.swift
//  chaptedfr
//
//  Created by JeonSangHyeok on 2023/08/07.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        image.loadImage()
    }
}

// 이미지 URL 다운로드 후 설정
extension UIImageView {
    func loadImage() {
        guard let url = URL(string: "https://spartacodingclub.kr/css/images/scc-og.jpg") else { return }
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
