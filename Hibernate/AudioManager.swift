//
//  AudioManager.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-05-08.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import Foundation
import AVFoundation

class AudioManager {
    var audioPlayer : AVAudioPlayer?
    
    init () {
        audioPlayer = nil
    }
    
    //Play sample alarm/sleep aid music
    func playSampleMusic(songName: String) -> Void {
        let url = Bundle.main.url(forResource: songName, withExtension: "mp3")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("could not play music")
        }
    }
    
    //Play sleep aid music
    func playSleepMusic(songName: String, for duration: Int) -> Void {
        let url = Bundle.main.url(forResource: songName, withExtension: "mp3")!
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            let numOfLoops = 15/duration - 1
            audioPlayer?.numberOfLoops = numOfLoops
            audioPlayer?.play()
        } catch {
            print("could not play sleep music")
        }
    }
    
    //Fade out and stop playing all music
    func fadeOutMusic() {
        audioPlayer?.setVolume(0, fadeDuration: 1)
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(Timer)->Void in
            self.audioPlayer?.stop()
        })
    }
    
    //Stop audio player
    func stopPlayingMusic() {
        audioPlayer?.stop()
    }
}
