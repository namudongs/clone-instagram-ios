//
//  LoginController.swift
//  InstagramFirebaseTutorial
//
//  Created by namdghyun on 2023/05/22.
//

import UIKit

class LoginController: UIViewController {
    
    // MARK: - 속성
    
    private var viewModel = LoginViewModel()
    
    private let iconImage: UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white"))
        iv.contentMode = .scaleAspectFill
        return iv
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
    
    private let loginButton: UIButton = {
        let button = CustomButton(placeholder: "로그인")
        button.isEnabled = false
        return button
    }()
    
    private let forgotPasswordButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "비밀번호를 잊으셨나요? ", secondPart: "비밀번호 찾기")
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "계정이 없으신가요? ", secondPart: "회원가입 하기")
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
    @objc func handleLogin() {
        loginButton.showBounceAnimation()
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        AuthService.logUserIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("디버그: 로그인에 실패했습니다 \(error.localizedDescription)")
                return
            }
            
            self.dismiss(animated: true)

        }
    }
    
    @objc func handleShowSignUp() {
        let controller = RegistrationCotnroller()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        
        updateForm()
    }
    
    // MARK: - 도우미
    func configureUI() {
        configureGradientLayer()
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 80, width: 120)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        
        let stack = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton, forgotPasswordButton])
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
        
    }
    
    func configureNotificationObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func buttonTarget() {
        dontHaveAccountButton.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }
}

// MARK: - 업데이트폼
extension LoginController: FormViewModel {
    func updateForm() {
        loginButton.backgroundColor = viewModel.buttonBackgroundColor
        loginButton.setTitleColor(viewModel.buttonTitleColor, for: .normal)
        loginButton.isEnabled = viewModel.formIsValid
    }
}

