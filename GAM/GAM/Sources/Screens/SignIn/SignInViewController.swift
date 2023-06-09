//
//  SignInViewController.swift
//  GAM
//
//  Created by Jungbin on 2023/06/30.
//

import UIKit
import SnapKit
import KakaoSDKUser

final class SignInViewController: BaseViewController {
    
    enum Text {
        static let info = "로그인 시 이용약관과 개인정보 처리 방침에 동의하게 됩니다."
        static let privacyPolicy = "개인정보 처리 방침"
        static let terms = "이용약관"
    }
    
    // MARK: UIComponents
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: .gamLogoKorean)
        return imageView
    }()
    
    private let appleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.appleLogin, for: .normal)
        return button
    }()
    
    private let kakaoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.kakaoLoginMediumWide, for: .normal)
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = Text.info
        label.textColor = .gamWhite
        label.font = .caption1Regular
        label.setHyperlinkedStyle(to: [Text.privacyPolicy, Text.terms], with: .caption1Regular)
        label.sizeToFit()
        return label
    }()
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUI()
        self.setLayout()
        self.setKakaoButtonAction()
        self.setAppleButtonAction()
        self.setPrivacyPolicyLabelTapRecognizer()
    }
    
    // MARK: Methods
    
    private func setUI() {
        self.view.backgroundColor = .gamBlack
    }
    
    private func setKakaoButtonAction() {
        self.kakaoButton.setAction { [weak self] in
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoTalk() success.")
                        self?.present(BaseNavigationController(rootViewController: SignUpUsernameViewController()), animated: true)
                    }
                }
            } else {
                UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        print("loginWithKakaoAccount() success.")
                        self?.present(BaseNavigationController(rootViewController: SignUpUsernameViewController()), animated: true)
                    }
                }
            }
        }
    }
    
    private func setPrivacyPolicyLabelTapRecognizer() {
        self.infoLabel.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(privacyPolicyLabelTapped)
        )
        self.infoLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setAppleButtonAction() {
//        self.appleButton.setAction { [weak self] in
//            let appleIDProvider = ASAuthorizationAppleIDProvider()
//            let request = appleIDProvider.createRequest()
//            request.requestedScopes = [.fullName, .email]
//
//            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
//            authorizationController.delegate = self
//            authorizationController.presentationContextProvider = self
//            authorizationController.performRequests()
//        }
    }
    
    @objc private func privacyPolicyLabelTapped(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self.infoLabel)
        
        if let calaulatedTermsRect = self.infoLabel.boundingRectForCharacterRange(subText: Text.terms),
           calaulatedTermsRect.contains(point) {
            if let url = URL(string: "https://www.daum.net") {
                self.openSafariInApp(url: url)
            }
        }
        
        if let privacyPolicyRect = self.infoLabel.boundingRectForCharacterRange(subText: Text.privacyPolicy),
           privacyPolicyRect.contains(point) {
            if let url = URL(string: "https://www.naver.com") {
                self.openSafariInApp(url: url)
            }
        }
    }
}

// MARK: - UI

extension SignInViewController {
    private func setLayout() {
        self.view.addSubviews([logoImageView, infoLabel, kakaoButton,  appleButton])
        
        self.logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(272.adjustedH)
            make.width.equalTo(110)
            make.height.equalTo(75.74)
        }
        
        self.infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide).inset(48)
        }
        
        self.kakaoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.infoLabel.snp.top).offset(-12)
        }
        
        self.appleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.kakaoButton.snp.top).offset(-10)
        }
    }
}
