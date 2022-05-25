//
//  YFLAudioManager.swift
//  YFLKit
//
//  Created by Even Lin on 2022/5/7.
//

import AVKit
import AVFAudio

public class YFLAudioManager: NSObject {
    
    /// 录制器
    private var recorder: AVAudioRecorder?
    
    /// 本地播放器
    private var audioPlayer: AVAudioPlayer?
    
    /// 在线播放器
    private var avPlayer: AVPlayer?
    
    /// 录制结束回调
    private var complete: CompleteB?
    
    /// 播放结束回调
    private var playComplete: CompleteB?
    
    /// 音频Session设置
    private func audioSessionConfig() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error {
            YFLog(error.localizedDescription)
        }
        
    }
    
    /// 录制音频的存放路径
    public func pathForRecordFile() -> String {
        let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        //音频格式是否有要求 不能使用M4a
        return cachePath + "/voice.wav"
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: Recorder
extension YFLAudioManager {
    
    /// 开始录制音频
    /// - Parameter complete: delegate 录制结束回调
    public func startRecord(complete: CompleteB?) {
        guard let url = URL(string: pathForRecordFile()) else {return}
        guard let format = AVAudioFormat(standardFormatWithSampleRate: 44100, channels: 1) else { return }
        self.complete = complete
        audioSessionConfig()
        do {
            try recorder = AVAudioRecorder(url: url, format: format)
        } catch let error {
            YFLog(error.localizedDescription)
        }
        recorder?.delegate = self
        if recorder?.prepareToRecord() == true {
            YFLog("⏺⏺⏺ start record >>> ")
            recorder?.record(forDuration: 15)
        }
    }
    
    
    /// 停止录制音频
    public func stopRecord() {
        if recorder?.isRecording == true {
            recorder?.stop()
        }
    }
    
    /// 删除录音文件
    public func deleteRecord() {
        guard recorder?.isRecording == false else { return }
        recorder?.deleteRecording()
    }
}

extension YFLAudioManager: AVAudioRecorderDelegate {
    public func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        self.complete?(flag)
        if flag {
            YFLog("⏺⏺⏺ record succeeded 🎉🎉🎉")
        }
    }
}

//MARK: Player
extension YFLAudioManager {
    
    /// 播放录音文件
    /// - Parameter complete: 播放结束回调
    public func playRecord(complete: CompleteB?) {
        guard let fileUrl = URL(string: pathForRecordFile()) else { return }
        playRecord(url: fileUrl, complete: complete)
    }
    
    
    /// 播放音频文件
    /// - Parameters:
    ///   - url: 音频路径
    ///   - complete: 播放完成回调
    public func playRecord(url: URL?, complete: CompleteB?) {
        guard let fileUrl = url else { return }
        self.playComplete = complete
        if fileUrl.absoluteString.hasPrefix("http") {
            playOnlineRecord(fileUrl)
        } else {
            playLocalRecord(fileUrl)
        }
    }
    
    /// 是否正在播放音频
    /// - Returns: 返回Bool值
    public func isPlaying() -> Bool {
        return audioPlayer?.isPlaying ?? false
    }
    
    /// 停止播放音频
    public func stopPlayRecord() {
        if audioPlayer?.isPlaying == true {
            audioPlayer?.stop()
        }
        avPlayer?.pause()
    }
    
    private func playOnlineRecord(_ url: URL) {
        self.avPlayer = AVPlayer(url: url)
        self.avPlayer?.isMuted = false
        self.avPlayer?.actionAtItemEnd = .pause
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(self, selector: #selector(playEndAction), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        self.avPlayer?.play()
    }
    
    private func playLocalRecord(_ url: URL) {
        do {
            try audioPlayer = AVAudioPlayer.init(contentsOf: url)
        } catch let error {
            YFLog(error.localizedDescription)
        }
        
        if audioPlayer?.prepareToPlay() == true {
            audioPlayer?.delegate = self
            audioPlayer?.play()
        }
    }
    
    @objc private func playEndAction() {
        playComplete?(true)
    }
}

extension YFLAudioManager: AVAudioPlayerDelegate {
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.playComplete?(flag)
        if flag {
            YFLog("play did finish")
        }
    }
}
