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
    var sleepSoundName : String!
    var didLeaveSleepSoundsSetting = false //Track whether to fade out audio
    var audioOn = false //Track whether the soundtrack is playing
    var premiumSoundPressed : Bool = false
    
    var grayImage : UIImage!
    var originalImage : UIImage!
    
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
        
        //If not the currently sleeping sound, image is gray
        var currentSleepSoundName = UserDefaults.standard.string(forKey: "sleepSound")
        if currentSleepSoundName == nil {
            //If sound name is nil somehow, set default to light rain
            currentSleepSoundName = "Light Rain"
        }
        self.image! = (sleepSoundName == currentSleepSoundName ? originalImage : grayImage)
        changeToGrayscaleWhenNotSelected()
    }
    
    private func premiumSoundSelected () -> Bool {
        if sleepSoundName == "Light Rain" || sleepSoundName == "Stream" {
            return false
        } else {
            return true
        }
    }
    
    private func changeToGrayscaleWhenNotSelected() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: {(Timer)->Void in
            var currentSleepSoundName = UserDefaults.standard.string(forKey: "sleepSound")
            if currentSleepSoundName == nil {
                //If sound name is nil somehow, set default to light rain
                currentSleepSoundName = "Light Rain"
            }
            self.image! = (self.sleepSoundName == currentSleepSoundName ? self.originalImage : self.grayImage)
        })
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        audioOn = !audioOn
        premiumSoundPressed = premiumSoundSelected()
        
        //Bounce animation
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 6, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity}, completion: nil)
        
        //Play sample music if image sound corresponds to the selected sleep sound
        if audioOn == true {
            audioManager.playSampleMusic(songName: sleepSoundName)
            //Store chosen sleep sound to user defaults
        } else if audioOn == false {
            //Stop if pressed again
            audioManager.stopPlayingMusic()
        }
        
        UserDefaults.standard.set(sleepSoundName, forKey: "sleepSound")
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {(Timer)->Void in
            //Fade out music when settings left
            if self.didLeaveSleepSoundsSetting {
                self.audioManager.fadeOutMusic()
            }
            
            //Stop playing music when other image selected
            var currentSleepSoundName = UserDefaults.standard.string(forKey: "sleepSound")
            if currentSleepSoundName == nil {
                //If sound name is nil somehow, set default to light rain
                currentSleepSoundName = "Light Rain"
            }
            if self.sleepSoundName != currentSleepSoundName {
                self.audioManager.stopPlayingMusic()
                self.audioOn = false
                //Turn to grayscale when not selected
                self.image! = self.grayImage
                //Set to false when not selected
                self.premiumSoundPressed = false
                Timer.invalidate()
            } else if self.sleepSoundName == currentSleepSoundName {
                //Colored original picture when image is selected
                self.image! = self.originalImage
            }
        })
    }
}
