//
//  WeatherLoadingOverlay.swift
//  ForecastFiesta
//
//  Created by Rohin Madhavan on 22/06/2025.
//

import UIKit

import UIKit

class WeatherLoadingOverlay: UIView {
    
    private let blurView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private let weatherSpinner: UIImageView = {
        let config = UIImage.SymbolConfiguration(pointSize: 60, weight: .medium)
        let image = UIImage(systemName: "sun.max.fill", withConfiguration: config)
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        self.addSubview(blurView)
        self.addSubview(weatherSpinner)

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            weatherSpinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            weatherSpinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])

        startSpinning()
    }

    private func startSpinning() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1.2
        rotation.repeatCount = .infinity
        weatherSpinner.layer.add(rotation, forKey: "rotate")
    }

    func stop() {
        DispatchQueue.main.async {
            self.weatherSpinner.layer.removeAnimation(forKey: "rotate")
        }
        self.removeFromSuperview()
    }
}
