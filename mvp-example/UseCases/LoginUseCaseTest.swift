//
//  LoginUseCaseTest.swift
//  mvp-exampleTests
//
//  Created by unagami on 2022/08/23.
//

@testable import mvp_example
import XCTest

final class LoginUseCaseTest: XCTestCase {
    private var repositoryMock: UserRepositoryProtocolMock!
    private var useCase: LoginUseCaseProtocol!

    override func setUpWithError() throws {
        self.repositoryMock = UserRepositoryProtocolMock()
        self.useCase = LoginUseCase(userRepository: self.repositoryMock)
    }

    func test_invoke_正常系() throws {
        XCTContext.runActivity(named: "リポジトリのパラメータを検証") { _ in
            self.repositoryMock.singinHandler = { (userName, password) in
                XCTAssertEqual("#user", userName)
                XCTAssertEqual("#password", password)
            }
        }

        self.runAsyncTest {
            try await self.useCase.invoke(userName: "#user", password: "#password")
        } catchError: { _ in
            XCTFail("Unreachable")
        }

        XCTContext.runActivity(named: "リポジトリメソッドの呼び出しを検証") { _ in
            XCTAssertEqual(1, self.repositoryMock.singinCallCount)
        }
    }

    func test_invoke_異常系_userNameEmpty() throws {
        self.runAsyncTest {
            try await self.useCase.invoke(userName: "", password: "#password")
            XCTFail("Unreachable")
        } catchError: { _ in
            // NOP
        }

        XCTContext.runActivity(named: "リポジトリメソッドの呼び出しを検証") { _ in
            XCTAssertEqual(0, self.repositoryMock.singinCallCount)
        }
    }

    func test_invoke_異常系_passwordEmpty() throws {
        self.runAsyncTest {
            try await self.useCase.invoke(userName: "#user", password: "")
            XCTFail("Unreachable")
        } catchError: { _ in
            // NOP
        }

        XCTContext.runActivity(named: "リポジトリメソッドの呼び出しを検証") { _ in
            XCTAssertEqual(0, self.repositoryMock.singinCallCount)
        }
    }
}