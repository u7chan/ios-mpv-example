//
//  LoginPresenter.swift
//  mvp-example
//
//  Created by unagami on 2022/08/17.
//

import Foundation

final class LoginPresenter {
    private weak var view: LoginViewProtocol?

    private let loginUseCase: LoginUseCaseProtocol

    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }
}

// MARK: - LoginPresenterProtocol

extension LoginPresenter: LoginPresenterProtocol {
    func attachView(view: LoginViewProtocol) {
        self.view = view
    }

    func doLogin(userName: String, password: String) {
        self.view?.showProgress()
        runCatch {
            try await self.loginUseCase.invoke(userName: userName, password: password)
        } success: {
            self.view?.hideProgress()
            self.view?.navigateToDashboard()
        } failure: { error in
            self.view?.hideProgress()
            switch error {
            case ApiError.networkUnableError:
                self.view?.showError(message: "ネットワークに接続できませんでした")
            default:
                self.view?.showError(message: "予期せぬエラーが発生しました")
            }
        }
    }
}
