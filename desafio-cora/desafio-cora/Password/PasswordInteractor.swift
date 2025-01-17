import Foundation

protocol PasswordInteracting: AnyObject {
    func extractScene()
    func lostPassword()
}

final class PasswordInteractor {
    private let presenter: PasswordPresenting

    init(presenter: PasswordPresenting) {
        self.presenter = presenter
    }
}

// MARK: - PasswordInteracting
extension PasswordInteractor: PasswordInteracting {
    func extractScene() {
        presenter.didNextStep(action: .extractScene)
    }
    
    func lostPassword() {
        presenter.didNextStep(action: .lostPassword)
    }
}
