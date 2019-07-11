//
//  LoginController.swift
//  FirebaseChatApp
//
//  Created by sarkom-1 on 06/05/19.
//  Copyright © 2019 Aerials. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    //INPUT view
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        //permisison autolayout
        view.translatesAutoresizingMaskIntoConstraints = false
        //corner radius
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        
        return view
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login","Register"])
        
        //permission autolayout
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        
        return sc
    }()
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        //gambar dari asset
        imageView.image = UIImage(named: "vp.png")
        //permission autolayout
        imageView.translatesAutoresizingMaskIntoConstraints = false
        //content mode
        imageView.contentMode = .scaleAspectFill
        //add click action
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleProfileImageView)))
        //permission for click
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor(r: 219, g: 100, b: 30)
        
        //permission
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLoginRegisterButton), for: .touchUpInside)
        
        return button
        
    }()
    
    let nameTF: UITextField = {
        let TF = UITextField()
        TF.translatesAutoresizingMaskIntoConstraints = false
        TF.placeholder = "Name"
        
        return TF
    }()
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 252, g: 100, b: 10)
        
        return view
    }()
    let emailTF: UITextField = {
        let TF = UITextField()
        TF.translatesAutoresizingMaskIntoConstraints = false
        TF.placeholder = "Email"
        
        return TF
    }()
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 252, g: 100, b: 10)
        
        return view
    }()
    let passwordTF: UITextField = {
        let TF = UITextField()
        TF.translatesAutoresizingMaskIntoConstraints = false
        TF.placeholder = "Password"
        TF.isSecureTextEntry = true
        
        return TF
    }()
    let passwordSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(r: 252, g: 100, b: 10)
        
        return view
    }()
    
    var messageController: MessageController?
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(r: 252, g: 100, b: 10)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterSegmentedControl)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterButton)
        
        setupInputContainerView()
        setupLoginRegisterSegmented()
        setupProfileImageView()
        setupLoginRegisterButton()
        
    }
    
    var inputConstrainViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    func setupInputContainerView() {
        // horizontal
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // vertical
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        // width
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30).isActive = true
        // height
        inputConstrainViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        
        inputConstrainViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameTF)
        inputContainerView.addSubview(nameSeparatorView)
        inputContainerView.addSubview(emailTF)
        inputContainerView.addSubview(emailSeparatorView)
        inputContainerView.addSubview(passwordTF)
        
        //autolayout for TextField
        //Email textfield
        nameTF.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTF.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextFieldHeightAnchor = nameTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        nameTF.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        nameSeparatorView.topAnchor.constraint(equalTo: nameTF.bottomAnchor).isActive = true
        nameSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSeparatorView.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //NAME textfield
        emailTF.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        emailTF.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextFieldHeightAnchor = emailTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        emailTF.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        
        emailSeparatorView.topAnchor.constraint(equalTo: emailTF.bottomAnchor).isActive = true
        emailSeparatorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSeparatorView.rightAnchor.constraint(equalTo: inputContainerView.rightAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //NAME textfield
        passwordTF.topAnchor.constraint(equalTo: emailSeparatorView.bottomAnchor).isActive = true
        passwordTF.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTF.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor =  passwordTF.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    func setupLoginRegisterSegmented() {
        //setup autolayout
        
        // horizontal
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        // vertical
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -15).isActive = true
        // width
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, multiplier: 1).isActive = true
        // height
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    func setupProfileImageView() {
        //setup auto layout
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -15).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 13).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
}

