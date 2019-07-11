//
//  ChatMessageCell.swift
//  FirebaseChatApp
//
//  Created by sarkom-1 on 09/05/19.
//  Copyright © 2019 Aerials. All rights reserved.
//

import UIKit
import AVFoundation

class ChatMessageCell: UICollectionViewCell {
    
    var message: Messages?
    var chatLogController: ChatLogController?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.hidesWhenStopped = true
        
        
        return aiv
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "play")
        button.tintColor = .white
        button.setImage(image, for: .normal)
        
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        
        return button
    }()
    let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .clear
        tv.textColor = .white
        tv.isEditable = false
        
        return tv
    }()
    
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    let bubleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = blueColor
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    lazy var messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return imageView
    }()
    
    var playerLayer: AVPlayerLayer?
    var player: AVPlayer?
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    @objc func handlePlay(){
        if let videoUrlString = message?.videoUrl, let url = URL(string: videoUrlString){
            player = AVPlayer(url: url)
            
            playerLayer = AVPlayerLayer(player: player)
            playerLayer?.frame = bubleView.bounds
            bubleView.layer.addSublayer(playerLayer!)
            
            player?.play()
            activityIndicatorView.startAnimating()
            playButton.isHidden = true
        }
    }
    
    @objc func handleZoomTap(_ tapGesture: UITapGestureRecognizer) {
        if message?.videoUrl != nil {
            return
        }
        
        if let imageView = tapGesture.view as? UIImageView {
            //PRO Tip: don't perform a lot of custom logic inside of a view class
            //self.chatLogController?.performZoomInForStartingImageView()
            self.chatLogController?.performZoomInForStartingImageView(imageView)
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        player?.pause()
//        activityIndicatorView.startAnimating()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        bubleView.addSubview(messageImageView)
        messageImageView.leftAnchor.constraint(equalTo: bubleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubleView.heightAnchor).isActive = true
        
        bubleView.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: bubleView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: bubleView.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor,constant: 8).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        bubbleViewRightAnchor = bubleView.rightAnchor.constraint(equalTo: rightAnchor, constant:  -8)
        bubbleViewRightAnchor?.isActive = true
        
        bubbleViewLeftAnchor = bubleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant:  8)
        
        bubleView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        bubbleWidthAnchor = bubleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        bubleView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        textView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        textView.leftAnchor.constraint(equalTo: bubleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubleView.rightAnchor).isActive = true
        
        bubleView.addSubview(playButton)
        
        playButton.centerXAnchor.constraint(equalTo: bubleView.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: bubleView.centerYAnchor).isActive = true
        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        bringSubviewToFront(playButton)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
