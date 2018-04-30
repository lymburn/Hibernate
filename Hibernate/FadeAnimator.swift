//
//  FadeAnimator.swift
//  Hibernate
//
//  Created by Eugene Lu on 2018-04-30.
//  Copyright © 2018 Eugene Lu. All rights reserved.
//

import UIKit

//Manages code to transition between VC's
class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 1.0
    var presenting = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        toView.alpha = 0.0
        UIView.animate(withDuration: duration, animations: {toView.alpha = 1.0},
                       completion: { _ in transitionContext.completeTransition(true)})
    }
}
