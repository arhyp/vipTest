//
//  GIPHYCollectionViewCell.swift
//  VIPTest
//
//  Created by Архип on 10/23/17.
//  Copyright © 2017 KoshelGROUP. All rights reserved.
//

import UIKit
import SDWebImage

class GIPHYCollectionViewCell: UICollectionViewCell {
    private var disGiphy : ListGIPHYs.FetchList.ViewModel.DisplayedGIPHY? = nil
    
    var displayedGiphy: ListGIPHYs.FetchList.ViewModel.DisplayedGIPHY? {
        set {
            self.disGiphy = newValue
            self.updateUI()
        }
        get {
            return self.disGiphy
        }
    }
    
    @IBOutlet weak var giphyImageView: FLAnimatedImageView!
    @IBOutlet weak var giphyLabel: UILabel!
    
    func updateUI(){
        self.giphyLabel.text = self.displayedGiphy?.title
        if let url = self.displayedGiphy?.url{
            giphyImageView.sd_setShowActivityIndicatorView(true)
            giphyImageView.sd_setIndicatorStyle(.white)
            
            
            self.giphyImageView.sd_setImage(with: NSURL(string: url)! as URL, placeholderImage: nil, options: [])
            
            

        }else {
            self.giphyImageView.image = nil;
        }
        
    }
}
