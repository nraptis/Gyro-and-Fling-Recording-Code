//
//  MagicalSliderViewModel+AnimationGrabSpeed.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 12/7/24.
//

import Foundation

@Observable class MagicalSliderViewModelAnimationGrabSpeed: MagicalSliderViewModel {
    
    override func refresh() {
        
        if let jiggleViewModel = ApplicationController.shared.jiggleViewModel {
            if let selectedJiggle = jiggleViewModel.getSelectedJiggle() {
                
                if jiggleViewModel.getContinuousDraggingStatus() {
                    refreshDisabled(value: selectedJiggle.grabSpeed)
                    return
                }
                
                if jiggleViewModel.isSliderActiveBesides(thisSlider: .sliderAnimationGrabSpeed) {
                    refreshDisabled(value: selectedJiggle.grabSpeed)
                } else {
                    refreshEnabled(value: selectedJiggle.grabSpeed)
                }
            } else {
                refreshDisabled()
            }
        }
        
    }
    
    deinit {
        if ApplicationController.DEBUG_DEALLOCS {
            print("MagicalSlider GrabSpeed - Dealloc")
        }
    }
    
    override func handleSlideStarted(percent: CGFloat) {
        super.handleSlideStarted(percent: percent)
        if let jiggleViewModel = ApplicationController.shared.jiggleViewModel {
            let value = sliderConfiguration.minimumValue + (sliderConfiguration.maximumValue - sliderConfiguration.minimumValue) * Float(percent)
            jiggleViewModel.notifySliderStartedAnimationGrabSpeed(value: value)
        }
    }
    
    override func handleSlideUpdated(percent: CGFloat) {
       
        if let jiggleViewModel = ApplicationController.shared.jiggleViewModel {
            let value = sliderConfiguration.minimumValue + (sliderConfiguration.maximumValue - sliderConfiguration.minimumValue) * Float(percent)
            if jiggleViewModel.isAnimationGrabAppliedToAll {
                let jiggleDocument = jiggleViewModel.jiggleDocument
                for jiggleIndex in 0..<jiggleDocument.jiggleCount {
                    let jiggle = jiggleDocument.jiggles[jiggleIndex]
                    jiggle.grabSpeed = value
                }
            } else {
                if let selectedJiggle = jiggleViewModel.getSelectedJiggle() {
                    selectedJiggle.grabSpeed = value
                }
            }
        }
        super.handleSlideUpdated(percent: percent)
    }
    
    override func handleSlideFinished(percent: CGFloat) {
        super.handleSlideFinished(percent: percent)
        
        if let jiggleViewModel = ApplicationController.shared.jiggleViewModel {
            var value = sliderConfiguration.minimumValue + (sliderConfiguration.maximumValue - sliderConfiguration.minimumValue) * Float(percent)
            
#if GYRO_CAPTURE || FLING_CAPTURE
            if value > 80 {
                value = 100
            } else if value > 60 {
                value = 75
            } else if value > 40 {
                value = 50
            } else if value > 20 {
                value = 25
            } else {
                value = 0
            }
            super.handleSlideFinished(percent: CGFloat(value / sliderConfiguration.maximumValue))
#endif
            
            
            if jiggleViewModel.isAnimationGrabAppliedToAll {
                let jiggleDocument = jiggleViewModel.jiggleDocument
                for jiggleIndex in 0..<jiggleDocument.jiggleCount {
                    let jiggle = jiggleDocument.jiggles[jiggleIndex]
                    jiggle.grabSpeed = value
                }
            } else {
                if let selectedJiggle = jiggleViewModel.getSelectedJiggle() {
                    selectedJiggle.grabSpeed = value
                }
            }
            jiggleViewModel.notifySliderFinishedAnimationGrabSpeed(value: value)
        }
    }
}
