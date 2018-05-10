//
//  SleepSoundImage.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-09.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

//Custom class for image views that are correspond to sleeping sounds
class SleepSoundImage : UIImageView {
    var audioManager = AudioManager()
    var sleepSoundName : String?
    var didLeaveSleepSoundsSetting = false //Track whether to fade out audio
    var didPress = true //Track whether the soundtrack has been pressed once already
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        didPress = !didPress
        
        //Bounce animation
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity}, completion: nil)
        
        //Play sample music
        if sleepSoundName != nil && !didPress {
            audioManager.playSampleMusic(songName: sleepSoundName!)
        } else if didPress {
            //Stop if pressed again
            audioManager.stopPlayingMusic()
        }
        
        //Store chosen sleep sound to user defaults
        UserDefaults.standard.set(sleepSoundName, forKey: "sleepSound")
        
        //Fade out music when settings left
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: {(Timer)->Void in
            if self.didLeaveSleepSoundsSetting {
                self.audioManager.fadeOutMusic()
            }
        })
    }
}
