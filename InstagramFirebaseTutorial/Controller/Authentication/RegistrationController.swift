//
//  RegistrationController.swift
//  InstagramFirebaseTutorial
//
//  Created by namdghyun on 2023/05/22.
//

import UIKit

class RegistrationCotnroller: UIViewController {
    
    // MARK: - 속성
    
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    
    private let plushPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let emailTextField: UITextField = {
        let tf = CustonTextField(placeholder: "이메일")
        tf.keyboardType = .emailAddress
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = CustonTextField(placeholder: "비밀번호")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextField = CustonTextField(placeholder: "이름")
    private let usernameTextField = CustonTextField(placeholder: "닉네임")
    
    private let signUpButton: UIButton = {
        let button = CustomButton(placeholder: "회원가입")
        button.isEnabled = false
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "계정이 이미 있으신가요? ", secondPart: "로그인 화면으로 돌아가기")
        return button
    }()
    
    // MARK: - 생명주기
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()
        buttonTarget()
    }
    
    // MARK: - 액션
    @objc func handleSignUp() {
        signUpButton.showBounceAnimation()
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        guard let profileImage = self.profileImage else { return }
        
        let credeentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.registerUser(withCredential: credeentials) { error in
            if let error = error {
                print("디버그: 회원가입에 실패했습니다 \(error.localizedDescription)")
                return
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else if sender == passwordTextField {
            viewModel.password = sender.text
        } else if sender == fullnameTextField {
            viewModel.fullname = sender.text
        } else if sender == usernameTextField {
            viewModel.username = sender.text
        }

        updateForm()
    }
    
    @objc func handleProfilePhotoSelect() {
        plushPhotoButton.showBounceAnimation()
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - 도우미
    func configureUI() {
        configureGradientLayer()
        
        view.addSubview(plushPhotoButton)
        plushPhotoButton.centerX(inView: view)
        plushPhotoButton.setDimensions(height: 140, width: 140)
        plushPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, fullnameTextField, usernameTextField, signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: plushPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
        
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullnameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        usernameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func buttonTarget() {
        alreadyHaveAccountButton.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        plushPhotoButton.addTarget(self, action: #selector(handleProfilePhotoSelect), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    }
}

// MARK: - 업데이트폼
extension RegistrationCotnroller: FormViewModel {
    func updateForm() {
        signUpButton.backgroundColor = viewModel.buttonBackgroundColor
        signUpButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        signUpButton.isEnabled = viewModel.formIsValid
    }
}

// MARK: - 이미지 선택 델리게이트
extension RegistrationCotnroller: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        profileImage = selectedImage
        
        plushPhotoButton.layer.cornerRadius = plushPhotoButton.frame.width / 2
        plushPhotoButton.layer.masksToBounds = true
        plushPhotoButton.layer.borderColor = UIColor.white.cgColor
        plushPhotoButton.layer.borderWidth = 2
        plushPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true)
    }
}
