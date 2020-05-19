//
//  BoxInfoView.swift
//  ConstraintsInCode
//
//  Created by Guilherme B V Bahia on 19/05/20.
//  Copyright © 2020 Guilherme B V Bahia. All rights reserved.
//

import UIKit

@IBDesignable
class BoxInfoView: UIView {

    private var mainView: UIView!
    private var subViews = [UIView]()
    private var lastBottomConstraint: NSLayoutConstraint?
    private var lastTrailingConstraint: NSLayoutConstraint?
    
    private var wRegular = false
    private var hRegular = false
    private var orientationWasChanged = false
    
    private var contentInfo = [Int: [String]]()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        //let bundle = Bundle(for: type(of: self))
        //let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        //let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        let view = UIView()
        view.frame = bounds
        view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        view.backgroundColor = UIColor.darkGray
        addSubview(view)
        self.mainView = view
        
        //setupCorner(self.mainView)
        //setupShadow(self.mainView)
        
        checkSideBySide()
        
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.orientationChanged(notification:)),
                                               name: UIDevice.orientationDidChangeNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }
    
    override var intrinsicContentSize : CGSize {
     
        return CGSize(width: 100.0, height: 100.0)
     
    }
    // Called when device orientation changes
    @objc private func orientationChanged(notification: Notification) {
        checkSideBySide()
        if orientationWasChanged {
            clear()
            fill()
        } else {
            print("Ops no change...")
        }
    }
    
    func addLabels(at boxPosition: Int, titlesValues: [String]) {
        contentInfo.updateValue(titlesValues, forKey: boxPosition)
    }
    
    func updateBox() {
        clear()
        fill()
    }
    
    private func clear() {
        self.mainView.subviews.forEach { $0.removeFromSuperview() }
    }
    
    private func fill() {
        subViews = [UIView]()
        let sortedArrayTuples = contentInfo.sorted() {$0.key < $1.key}
        for tuple in sortedArrayTuples {
            if subViews.count - 1 < tuple.key {
                    createSubView()
            }
            
            var constraints = [NSLayoutConstraint]()
            let viewToFill = subViews[tuple.key]
                var idx = 0
                var lastLabelTitle: UILabel?
                var lastLabelValue: UILabel?
                
                while idx < tuple.value.count {
                    let labelTitle = UILabel()
                    labelTitle.translatesAutoresizingMaskIntoConstraints = false
                    labelTitle.text = tuple.value[idx]
                    let labelValue = UILabel()
                    labelValue.translatesAutoresizingMaskIntoConstraints = false
                    labelValue.text = "\(tuple.value[idx + 1])"
                    
                    let lastLine = idx + 2 >= tuple.value.count
                    
                    
                    labelTitle.textColor = UIColor.white
                    labelValue.textColor = UIColor.white
                    
                    labelTitle.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
                    labelValue.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
                    
                    labelTitle.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)
                    labelValue.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
                    
                    if lastLabelTitle == nil {
                        constraints.append(labelTitle.leadingAnchor.constraint(equalTo: viewToFill.leadingAnchor, constant: 5.0))
                        constraints.append(labelTitle.topAnchor.constraint(equalTo: viewToFill.topAnchor, constant: 5.0))
                        constraints.append(viewToFill.trailingAnchor.constraint(equalTo: labelValue.trailingAnchor, constant: 5.0))
                    } else {
                        constraints.append(labelTitle.leadingAnchor.constraint(equalTo: lastLabelTitle!.leadingAnchor, constant: 0.0))
                        constraints.append(labelTitle.topAnchor.constraint(equalTo: lastLabelTitle!.bottomAnchor, constant: 5.0))
                        constraints.append(lastLabelValue!.trailingAnchor.constraint(equalTo: labelValue.trailingAnchor, constant: 0.0))
                    }
                    
                    constraints.append(labelValue.leadingAnchor.constraint(greaterThanOrEqualTo: labelTitle.trailingAnchor, constant: 5.0))
                    constraints.append(labelValue.firstBaselineAnchor.constraint(equalTo: labelTitle.firstBaselineAnchor))
                    if lastLine {
                        constraints.append(viewToFill.bottomAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 5.0))
                    }
                    viewToFill.addSubview(labelTitle)
                    viewToFill.addSubview(labelValue)
                    
                    lastLabelTitle = labelTitle
                    lastLabelValue = labelValue
                    idx += 2
                }
            NSLayoutConstraint.activate(constraints)
        }
    }

    
    private func createSubView() {
        print(#function)
        let subView = UIView()
        subView.translatesAutoresizingMaskIntoConstraints = false
        subView.backgroundColor = UIColor.black
        setupCorner(subView)
        let constraints: [NSLayoutConstraint]!
        if let topView = subViews.last {
            
            if hRegular && wRegular {
                print("if 1")
                lastTrailingConstraint?.isActive = false
                constraints = [subView.topAnchor.constraint(equalTo: topView.topAnchor, constant: 0.0),
                               subView.leadingAnchor.constraint(equalTo: topView.trailingAnchor, constant: 5.0),
                               self.mainView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 5.0),
                               topView.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: 0.0),
                               subView.widthAnchor.constraint(equalTo: topView.widthAnchor, multiplier: 1.0)]
                lastTrailingConstraint = constraints[2]
            } else if wRegular {
                print("if 2")
                lastBottomConstraint?.isActive = false
                constraints = [subView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 5.0),
                               subView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 5.0),
                               self.mainView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 5.0),
                               self.mainView.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: 5.0)]
                lastBottomConstraint = constraints[3]
                
            } else {
                print("if 3")
                lastBottomConstraint?.isActive = false
                constraints = [subView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 5.0),
                               subView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 5.0),
                               self.mainView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 5.0),
                               self.mainView.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: 5.0)]
                lastBottomConstraint = constraints[3]
            }
            
        } else {
            constraints = [subView.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: 5.0),
                               subView.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 5.0),
                               self.mainView.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: 5.0),
                               self.mainView.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: 5.0)]
             lastBottomConstraint = constraints[3]
             lastTrailingConstraint = constraints[2]
        }
        
        self.mainView.addSubview(subView)
        NSLayoutConstraint.activate(constraints)
        subViews.append(subView)
        
    }
    
    private func checkSideBySide() {
         let vTrait = UITraitCollection(verticalSizeClass: .regular)
         let hTrait = UITraitCollection(horizontalSizeClass: .regular)
         
         let newHRegular =  self.traitCollection.containsTraits(in: vTrait)
         let newWRegular =   self.traitCollection.containsTraits(in: hTrait)
        
        if (newHRegular == hRegular && newWRegular == wRegular) {
            orientationWasChanged = false
            return
        } else {
            hRegular = newHRegular
            wRegular = newWRegular
            orientationWasChanged = true
        }
    }
    
    private func setupCorner(_ view: UIView,
                             radius: CGFloat = CGFloat(5.0),
                             maskedCorners: CACornerMask = [.layerMaxXMaxYCorner,
                                                            .layerMaxXMinYCorner,
                                                            .layerMinXMaxYCorner,
                                                            .layerMinXMinYCorner]) {
        view.layer.cornerRadius = CGFloat(5.0)
        view.layer.masksToBounds = true
        view.layer.maskedCorners = maskedCorners
    }
    
    private func setupShadow(_ view: UIView) {
        view.layer.shadowOpacity = Float(0.2)
        view.layer.shadowOffset = CGSize(width: 2, height: 1)
        view.layer.shadowRadius = CGFloat(2)
    }
}
