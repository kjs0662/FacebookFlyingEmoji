//
//  ViewController.swift
//  FacebookLiveStreamAnimation
//
//  Created by 김진선 on 2017. 12. 28..
//  Copyright © 2017년 JinseonKim. All rights reserved.
//

import UIKit

class ViewController: UIViewController  {
    
    lazy var buttonView: ButtonView = {
        let bv = ButtonView()
        bv.viewController = self
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(buttonView)
        buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        buttonView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        buttonView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
//    @objc func handleTap() {
//        (0...10).forEach { (_) in
//            generateAnimatedViews()
//        }
//    }
    
    //fileprivate is allow to access in same file.
    fileprivate func generateAnimatedViews(image: UIImage) {
        
        // the drand48() is the random number generator
//        let image = drand48() > 0.5 ? #imageLiteral(resourceName: "thumbs_up") : #imageLiteral(resourceName: "heart")
        let imageView = UIImageView(image: image)
        let dimension = 30 + drand48() * 10
        imageView.frame = CGRect(x: 0, y: 0, width: dimension, height: dimension)
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        
        animation.path = customPath().cgPath
        animation.duration = 4 + drand48() * 6
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        imageView.layer.add(animation, forKey: nil)
        view.addSubview(imageView)
    }
}

func customPath() -> UIBezierPath {
    let path = UIBezierPath()
    
    path.move(to: CGPoint(x: 0, y: 200))
    let endPoint = CGPoint(x: 400, y: 200)
    let cp1 = CGPoint(x: 100, y: 100)
    let cp2 = CGPoint(x: 200, y: 300)
    
    
    path.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
    
    path.addLine(to: endPoint)
    
    
    return path
}

class CurvedView: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = customPath()
        path.lineWidth = 3
        path.stroke()
    }
}

class ButtonCell: UICollectionViewCell {
    
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        self.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

class ButtonView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    var viewController: ViewController?
    
    let cellID = "cellID"
    let images = [#imageLiteral(resourceName: "thumbs_up"), #imageLiteral(resourceName: "heart"), #imageLiteral(resourceName: "haha"), #imageLiteral(resourceName: "wow"), #imageLiteral(resourceName: "sad"), #imageLiteral(resourceName: "angry")]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: cellID)
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ButtonCell
        cell.imageView.image = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        viewController?.generateAnimatedViews(image: images[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 6, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
