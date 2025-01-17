import UIKit

protocol PasswordDisplaying: AnyObject {
    //Display Protocol
}

private extension PasswordViewController.Layout {
    enum Size {
        static let imageHeight: CGFloat = 90.0
        static let navBarHeight: CGFloat = 44.0
    }
}

final class PasswordViewController: UIViewController {
    fileprivate enum Layout {}
    
    private lazy var navBar: UINavigationBar = {
        let navBar = UINavigationBar()
        let navItem = UINavigationItem(title: Strings.loginNavBarTitle)
        let backItem = UIBarButtonItem(image: Images.leftArrow, style: .done, target: self, action: #selector(backButtonTapped))
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.gray1]
        backItem.tintColor = Colors.backgroundColor
        navItem.leftBarButtonItem = backItem
        navBar.backgroundColor = Colors.gray4
        navBar.titleTextAttributes = textAttributes
        navBar.translatesAutoresizingMaskIntoConstraints = false
        navBar.setItems([navItem], animated: false)
        return navBar
    }()
    
    private lazy var passwordTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.passwordTitle
        label.font = Typography.getFont(.bold(size: 22))()
        label.numberOfLines = 0
        label.textColor = Colors.offBlack
        return label
    }()
    
    private lazy var eyeImage: UIImageView = {
        let image = UIImageView()
        let action = UITapGestureRecognizer(target: self, action: #selector(hidePasswordButtonTapped))
        image.image = Images.eyeHidden
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(action)
        return image
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .phonePad
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.font = Typography.getFont(.medium(size: 24))()
        textField.delegate = self
        return textField
    }()
    
    
    private lazy var passwordStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordTextField, eyeImage])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var lostPassword: UILabel = {
        let label = UILabel()
        let action = UITapGestureRecognizer(target: self, action: #selector(lostPasswordButtonTapped))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Strings.lostPassword
        label.font = Typography.getFont(.regular(size: 14))()
        label.numberOfLines = 0
        label.textColor = Colors.backgroundColor
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(action)
        return label
    }()
    
    private lazy var config: UIButton.Configuration = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = Colors.white
        config.buttonSize = .large
        config.cornerStyle = .large
        config.title = Strings.nextButtonTitle
        config.baseBackgroundColor = Colors.gray2
        config.titleAlignment = .leading
        config.image = Images.rightArrowWhite
        config.imagePadding = 200
        config.imagePlacement = .trailing
        return config
    }()
    
    private lazy var passwordButton: UIButton = {
        let action = UIAction(handler: { action in
            self.passwordButtonTapped()
        })
        let button = UIButton(configuration: config, primaryAction: action)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        passwordTextField.becomeFirstResponder()
    }
    
    private let interactor: PasswordInteracting
    
    init(interactor: PasswordInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - @objc Private Methods
@objc private extension PasswordViewController {
    func backButtonTapped(){
        navigationController?.popViewController(animated: true)
    }
    
    func lostPasswordButtonTapped(sender: UIGestureRecognizer) {
        interactor.lostPassword()
    }
    
    func hidePasswordButtonTapped(sender: UIGestureRecognizer) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    func passwordButtonTapped() {
        interactor.extractScene()
    }
}

extension PasswordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.passwordTextField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        passwordButton.isEnabled = true
        passwordButton.configuration?.baseBackgroundColor = Colors.backgroundColor
        return true
    }
}

extension PasswordViewController: ViewSetup {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            navBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navBar.heightAnchor.constraint(equalToConstant: Layout.Size.navBarHeight)
        ])
        
        NSLayoutConstraint.activate([
            passwordTitle.topAnchor.constraint(equalTo: navBar.bottomAnchor, constant: Spacing.space5),
            passwordTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            passwordTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space5),
            passwordTitle.heightAnchor.constraint(equalToConstant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            passwordStackView.topAnchor.constraint(equalTo: passwordTitle.bottomAnchor, constant: Spacing.space6),
            passwordStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            passwordStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space5),
            passwordStackView.heightAnchor.constraint(equalToConstant: 32.0)
        ])
        
        NSLayoutConstraint.activate([
            lostPassword.topAnchor.constraint(equalTo: passwordStackView.bottomAnchor, constant: Spacing.space7),
            lostPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            lostPassword.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space5),
            lostPassword.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        
        NSLayoutConstraint.activate([
            passwordButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -Spacing.space5),
            passwordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Spacing.space5),
            passwordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Spacing.space5),
            passwordButton.heightAnchor.constraint(equalToConstant: 48.0)
        ])
        
        NSLayoutConstraint.activate([
            eyeImage.heightAnchor.constraint(equalToConstant: 32.0),
            eyeImage.widthAnchor.constraint(equalToConstant: 32.0)
        ])
    }
    
    func setupHierarchy() {
        view.addSubview(navBar)
        view.addSubview(passwordTitle)
        view.addSubview(passwordStackView)
        view.addSubview(lostPassword)
        view.addSubview(passwordButton)
    }
    
    func setupStyles() {
        view.backgroundColor = Colors.white
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

// MARK: - PasswordDisplaying
extension PasswordViewController: PasswordDisplaying {
    //Para implementar ações na tela por meio de protocolo
}
