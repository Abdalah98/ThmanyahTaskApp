//
//  DetailsViewController.swift
//  ThmanyahTask
//
//  Created by Abdallah Omar on 17/08/2025.
//

import UIKit
import SDWebImage
class DetailsViewController: UIViewController {
    //MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var bodyLabel: UILabel!
    
    var payload: DetailPayload!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageView.sd_cancelCurrentImageLoad()
    }
    
    private func initView(){
        view.backgroundColor = .systemBackground
        title = "Details"
        titleLabel.text = payload.title
        subtitleLabel.text = payload.subtitle
        bodyLabel.text = payload.description?.htmlToPlainString
        if let url = payload.imageURL {
            imageView.sd_setImage(
                with: url,
                placeholderImage: UIImage(systemName: "photo"),
                options: [.continueInBackground, .scaleDownLargeImages, .retryFailed]
            )
        }
    }
}

