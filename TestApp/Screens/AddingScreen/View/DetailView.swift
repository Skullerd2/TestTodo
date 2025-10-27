import UIKit

class DetailView: UIViewController {
    
    //UI-elements
    
    private lazy var titleLabel: UILabel = {
        $0.text = "Tasks"
        $0.font = UIFont(name: "Inter Bold", size: 24)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var backButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = .white
        if viewModel.isEditing {
            $0.addTarget(self, action: #selector(updateTask), for: .touchUpInside)
        } else {
            $0.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        }
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    private lazy var titleBackground: UIView = {
        $0.roundBottomCorners(radius: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = #colorLiteral(red: 0.454395771, green: 0.5721556544, blue: 0.9948783517, alpha: 1)
        return $0
    }(UIView())
    
    private lazy var titleTextField: UITextField = {
        let attrPlaceholder = NSAttributedString(string: "Task Name", attributes: [
            .foregroundColor: #colorLiteral(red: 0.4549019608, green: 0.5721556544, blue: 0.9948783517, alpha: 0.7),
            .font: UIFont(name: "Inter Medium", size: 16)!
        ])
        
        $0.attributedPlaceholder = attrPlaceholder
        $0.font = UIFont(name: "Inter Medium", size: 16)
        $0.textColor = #colorLiteral(red: 0.4549019608, green: 0.5721556544, blue: 0.9948783517, alpha: 1)
        $0.layer.cornerRadius = 8
        $0.layer.borderWidth = 3
        $0.layer.borderColor = #colorLiteral(red: 0.4549019608, green: 0.5721556544, blue: 0.9948783517, alpha: 1).cgColor
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: 0))
        $0.leftViewMode = .always
        return $0
    }(UITextField())
    
    private lazy var checkbox: CustomCheckbox = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.borderWidth = 3
        $0.layer.cornerRadius = 20
        return $0
    }(CustomCheckbox(isSelected: false))
    
    private lazy var addingImageButton: UIButton = {
        let attrTitle = NSAttributedString(string: "Add Image", attributes: [
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "Inter Bold", size: 24)!
        ])
        $0.layer.cornerRadius = 16
        $0.backgroundColor = #colorLiteral(red: 0.4549019608, green: 0.5721556544, blue: 0.9948783517, alpha: 1)
        $0.setAttributedTitle(attrTitle, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(chooseImage), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private lazy var taskImageView: UIImageView = {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 3
        $0.layer.borderColor = #colorLiteral(red: 0.4549019608, green: 0.5721556544, blue: 0.9948783517, alpha: 1).cgColor
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = $0.image == nil
        $0.clipsToBounds = true
        return $0
    }(UIImageView())
    
    private lazy var imagePicker = UIImagePickerController()
    
    //Properties and System functions
    let viewModel: DetailViewModel
    var onTaskChanged: ((TaskModel) -> Void)?
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        titleTextField.delegate = self
        navigationController?.navigationBar.isHidden = true
        configureConstraints()
    }
    
    func configureView(title: String, completed: Bool, imageData: String?) {
        titleTextField.text = title
        checkbox.isCompleted = completed
        if let data = Data(base64Encoded: imageData ?? "value") {
            taskImageView.image = UIImage(data: data)
            taskImageView.isHidden = imageData == "value" || imageData == ""
        }
    }
    
    private func configureConstraints() {
        view.addSubview(titleBackground)
        titleBackground.addSubview(titleLabel)
        titleBackground.addSubview(backButton)
        view.addSubview(titleTextField)
        view.addSubview(checkbox)
        view.addSubview(taskImageView)
        view.addSubview(addingImageButton)
        
        //Header background
        NSLayoutConstraint.activate([
            titleBackground.topAnchor.constraint(equalTo: view.topAnchor),
            titleBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBackground.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: titleBackground.leadingAnchor, constant: 16),
            backButton.heightAnchor.constraint(equalTo: titleLabel.heightAnchor),
            backButton.widthAnchor.constraint(equalTo: backButton.heightAnchor),
            backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor)
        ])
        
        //Title of screen
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: titleBackground.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: titleBackground.bottomAnchor, constant: -16)
        ])
        
        //Title textfield
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: titleBackground.bottomAnchor, constant: 16),
            titleTextField.heightAnchor.constraint(equalToConstant: 48),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 16)
        ])
        
        //Checkbox
        NSLayoutConstraint.activate([
            checkbox.heightAnchor.constraint(equalToConstant: checkbox.layer.cornerRadius * 2),
            checkbox.widthAnchor.constraint(equalTo: checkbox.heightAnchor),
            checkbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkbox.centerYAnchor.constraint(equalTo: titleTextField.centerYAnchor)
        ])
        
        //ImageView
        NSLayoutConstraint.activate([
            taskImageView.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            taskImageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            taskImageView.heightAnchor.constraint(equalTo: taskImageView.widthAnchor),
            taskImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        //Button to add image
        NSLayoutConstraint.activate([
            addingImageButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            addingImageButton.widthAnchor.constraint(equalTo: taskImageView.widthAnchor),
            addingImageButton.heightAnchor.constraint(equalToConstant: 52),
            addingImageButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
}

//MARK: - Logic of view

extension DetailView {
    @objc private func addTask() {
        guard let name = titleTextField.text else {
            return
        }
        let task = TaskModel(
            id: String(viewModel.indexForNew),
            name: name == "" ? "Task Name" : name,
            completed: checkbox.isCompleted,
            photoBase64: taskImageView.image?.toBase64String(),
            date: Date.formattedDateTime())
        viewModel.addTask(task: task)
        onTaskChanged?(task)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func updateTask() {
        guard let name = titleTextField.text else {
            return
        }
        let task = TaskModel(id: viewModel.taskModel!.id,
                             name: name == "" ? "Task Name" : name,
                             completed: checkbox.isCompleted,
                             photoBase64: taskImageView.image?.toBase64String())
        viewModel.updateTask(task: task)
        onTaskChanged?(task)
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UIImagePickerController

extension DetailView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func chooseImage() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            taskImageView.isHidden = false
            taskImageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: TextField Delegate

extension DetailView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        return true
    }
}
