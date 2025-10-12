//
//  CustomCheckbox.swift
//  TestApp
//
//  Created by Vadim on 12.10.2025.
//

import UIKit

class CustomCheckbox: UIView {
    
    var isCompleted: Bool = false {
        didSet {
            backgroundColor = isCompleted ? #colorLiteral(red: 0.454395771, green: 0.5721556544, blue: 0.9948783517, alpha: 1) : .white
            checkmarkImageView.isHidden = !isCompleted
        }
    }
    
    private lazy var checkmarkImageView: UIImageView = {
        $0.image = UIImage(systemName: "checkmark")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = !isCompleted
        $0.contentMode = .scaleAspectFill
        return $0
    }(UIImageView())
    
    init(isSelected: Bool = false) {
        super.init(frame: .zero)
        self.isCompleted = isSelected
        configureConstraints()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.454395771, green: 0.5721556544, blue: 0.9948783517, alpha: 1).cgColor
    }
    
    private func configureConstraints() {
        addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            checkmarkImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 16),
            checkmarkImageView.heightAnchor.constraint(equalTo: checkmarkImageView.widthAnchor)
        ])
    }
}
