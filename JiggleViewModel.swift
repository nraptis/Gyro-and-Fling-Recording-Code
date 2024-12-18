//
//  JiggleViewModel.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 11/9/23.
//

import UIKit
import Combine

class JiggleViewModel {
    
    var _test_slide_scale = Float(1.0)
    func test_slide_scale(percent: Float) {
        print("test_slide_scale(\(percent))")
        _test_slide_scale = percent
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
            jiggle.animationCursorScale = percent
        }
    }
    
    var _test_slide_rotation = Float(1.0)
    func test_slide_rotation(percent: Float) {
        print("test_slide_rotation(\(percent))")
        _test_slide_rotation = percent
        
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
         
            jiggle.animationCursorRotation = percent
            
        }
    }
    
    
    
    
    func test_animm_001() {
        print("test_animm_001()")
        
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
            
            jiggle.animationCursorX = 0.0
            jiggle.animationCursorY = 0.0
            jiggle.animationCursorScale = 1.0
            jiggle.animationCursorRotation = 0.0
            
        }
        
    }
    
    func test_animm_002() {
        print("test_animm_002()")
        
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
            
            let radius1 = Jiggle.getAnimationCursorFalloffDistance_R1(measuredSize: jiggle.measuredSize)
            
            jiggle.animationCursorX = -radius1
            jiggle.animationCursorY = 0.0
            
        }
    }
    
    func test_animm_003() {
        print("test_animm_003()")
        
        /*
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
            
            let radius2 = Jiggle.getAnimationCursorFalloffDistance_R2(measuredSize: jiggle.measuredSize)
            
            jiggle.animationCursorX = -radius2
            jiggle.animationCursorY = 0.0
        }
        */
        
#if FLING_CAPTURE
        ApplicationController.shared.flingPlaybackIndex = 0
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
            jiggle.animationCursorX = 0.0
            jiggle.animationCursorY = 0.0
            jiggle.animationCursorScale = 1.0
            jiggle.animationCursorRotation = 0.0
            jiggle.animusInstructionGrab.cursorSpeedX = 0.0
            jiggle.animusInstructionGrab.cursorSpeedY = 0.0
            jiggle.animusInstructionGrab.MY_MAGIC_EXIFF_DATA = -100.0
            jiggle.animusInstructionGrab.BIGGEST_FLING = -100.0
            jiggle.animusInstructionGrab.BIGGEST_POWER = -100.0
        }
        
        ApplicationController.shared.stowedFlingDataX.removeAll()
        ApplicationController.shared.stowedFlingDataY.removeAll()
        
        ApplicationController.shared.fling_is_binary_search = true
        
#endif
        
    }
    
    func test_animm_004() {
        print("test_animm_004()")
        
#if GYRO_CAPTURE
        ApplicationController.shared.gyroPlaybackIndex = 0
        ApplicationController.gyroSmoothX = 0.0
        ApplicationController.gyroSmoothY = 0.0
        
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
            
            let measuredFX = Jiggle.getMeasurePercentLinear(measuredSize: jiggle.measuredSize)
            
            let BIGGEST_GYRO = jiggle.animusInstructionGrab.BIGGEST_GYRO
            let WW_DA_GYRO_MULT = jiggle.animusInstructionGrab.WW_DA_GYRO_MULT
            let radius2 = Jiggle.getAnimationCursorFalloffDistance_R2(measuredSize: jiggle.measuredSize)
            let radius3 = Jiggle.getAnimationCursorFalloffDistance_R3(measuredSize: jiggle.measuredSize)
            let targetRadius = radius2 + (radius3 - radius2) * 0.60
            
            print("[TOES] Jiggle, BIGGEST_GYRO = \(BIGGEST_GYRO) targetRadius = \(targetRadius)")
            print("[TOES] Jiggle, WW_DA_GYRO_MULT = \(WW_DA_GYRO_MULT)")
            print("[TOES] Jiggle Measure percent = \(measuredFX), measuredSize = \(jiggle.measuredSize)")
            
            jiggle.animationCursorX = 0.0
            jiggle.animationCursorY = 0.0
            jiggle.animationCursorScale = 1.0
            jiggle.animationCursorRotation = 0.0
            jiggle.animusInstructionGrab.BIGGEST_GYRO = -100.0
            jiggle.animusInstructionGrab.WW_DA_GYRO_MULT = -100.0
        }
#endif
        
#if FLING_CAPTURE
        ApplicationController.shared.flingPlaybackIndex = 0
        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
            let jiggle = jiggleDocument.jiggles[jiggleIndex]
            jiggle.animationCursorX = 0.0
            jiggle.animationCursorY = 0.0
            jiggle.animationCursorScale = 1.0
            jiggle.animationCursorRotation = 0.0
            jiggle.animusInstructionGrab.cursorSpeedX = 0.0
            jiggle.animusInstructionGrab.cursorSpeedY = 0.0
            jiggle.animusInstructionGrab.MY_MAGIC_EXIFF_DATA = -100.0
            jiggle.animusInstructionGrab.BIGGEST_FLING = -100.0
            jiggle.animusInstructionGrab.BIGGEST_POWER = -100.0
        }
        
        ApplicationController.shared.stowedFlingDataX.removeAll()
        ApplicationController.shared.stowedFlingDataY.removeAll()

#endif
        
        
        
    }
    
    
    
    var isZoomEnabled = false
    var isGraphEnabled = false
    
    
    
    func shouldCancelDoubleTap(point: Point,
                               touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        
        print("[$$$$$$] shouldCancelDoubleTap Source: \(touchTargetTouchSource) Point: \(point)")
        
        if isVideoExportEnabled { return false }
        if isVideoRecordEnabled { return false }
        if isZoomEnabled { return false }
        switch documentMode {
        case .view:
            return false
        case .edit:
            if jiggleDocument.isGuidesEnabled {
                if isGraphEnabled {
                    return false
                } else {
                    switch jiggleDocument.weightMode {
                    case .guides:
                        return false
                    case .points:
                        switch jiggleDocument.pointSelectionMode {
                        case .points:
                            if jiggleDocument.doesClickingPointSelectGuideControlPoint_IgnoringModes(point: point,
                                                                                                     touchTargetTouchSource: touchTargetTouchSource) {
                                print("[$$$$$$] Should *YES* cancel double tap from Guide Control Point!")
                                return true
                            } else {
                                print("[$$$$$$] Should *NOT* cancel double tap from Guide Control Point!")
                                return false
                            }
                        case .tans:
                            if jiggleDocument.doesClickingPointSelectGuideControlPointTanHandle_IgnoringModes(point: point,
                                                                                                              touchTargetTouchSource: touchTargetTouchSource) {
                                print("[$$$$$$] Should *YES* cancel double tap from Guide Tan Handle!")
                                return true
                            } else {
                                print("[$$$$$$] Should *NOT* cancel double tap from Guide Tan Handle!")
                                return false
                            }
                        case .both:
                            if jiggleDocument.doesClickingPointSelectGuideControlPoint_IgnoringModes(point: point,
                                                                                                     touchTargetTouchSource: touchTargetTouchSource) {
                                print("[$$$$$$] Should *YES* cancel double tap from Guide (BOTH) Control Point!")
                                return true
                            } else if jiggleDocument.doesClickingPointSelectGuideControlPointTanHandle_IgnoringModes(point: point,
                                                                                                                     touchTargetTouchSource: touchTargetTouchSource) {
                                print("[$$$$$$] Should *YES* cancel double tap from Guide (BOTH) Tan Handle!")
                                return true
                            } else {
                                print("[$$$$$$] Should *NOT* cancel double tap from Guide (BOTH)!")
                                return false
                            }
                        }
                    }
                }
                
            }
            
            switch jiggleDocument.editMode {
            case .jiggles:
                return false
            case .points:
                switch jiggleDocument.pointSelectionMode {
                case .points:
                    if jiggleDocument.doesClickingPointSelectJiggleControlPoint_IgnoringModes(point: point,
                                                                                              touchTargetTouchSource: touchTargetTouchSource) {
                        print("[$$$$$$] Should *YES* cancel double tap from Jiggle Control Point!")
                        return true
                    } else {
                        print("[$$$$$$] Should *NOT* cancel double tap from Jiggle Control Point!")
                        return false
                    }
                case .tans:
                    if jiggleDocument.doesClickingPointSelectJiggleControlPointTanHandle_IgnoringModes(point: point,
                                                                                                       touchTargetTouchSource: touchTargetTouchSource) {
                        print("[$$$$$$] Should *YES* cancel double tap from Jiggle Tan Handle!")
                        return true
                    } else {
                        print("[$$$$$$] Should *NOT* cancel double tap from Jiggle Tan Handle!")
                        return false
                    }
                case .both:
                    if jiggleDocument.doesClickingPointSelectJiggleControlPoint_IgnoringModes(point: point,
                                                                                              touchTargetTouchSource: touchTargetTouchSource) {
                        print("[$$$$$$] Should *YES* cancel double tap from Jiggle (BOTH) Control Point!")
                        return true
                    } else if jiggleDocument.doesClickingPointSelectJiggleControlPointTanHandle_IgnoringModes(point: point,
                                                                                                              touchTargetTouchSource: touchTargetTouchSource) {
                        print("[$$$$$$] Should *YES* cancel double tap from Jiggle (BOTH) Tan Handle!")
                        return true
                    } else {
                        print("[$$$$$$] Should *NOT* cancel double tap from Jiggle (BOTH)!")
                        return false
                    }
                }
            }
        }
    }
    
    var isAnimatingZoomOrPreciseFrames: Bool {
        
        if isResetPreciseMagnifiedBoxActive {
            return true
        }
        if isResetPreciseDistantBoxActive {
            return true
        }
        if isResetZoomActive {
            return true
        }
        return false
        
    }
    
    var isRenderOptionsEnabled = false
    
    static let lineScaleStandard = Float(0.8)
    static let pointScaleStandard = Float(Device.isPad ? 0.19 : 0.28)
    static let jiggleCenterScaleStandard = Float(0.22)
    static let weightCenterScaleStandard = Float(Device.isPad ? 0.26 : 0.38)
    
    static let lineScalePrecise = lineScaleStandard * (Device.isPad ? 1.4 : 1.2)
    static let pointScalePrecise = pointScaleStandard * (Device.isPad ? 1.4 : 1.2)
    static let jiggleCenterScalePrecise = jiggleCenterScaleStandard * (Device.isPad ? 1.2 : 1.2)
    static let weightCenterScalePrecise = weightCenterScaleStandard * (Device.isPad ? 1.2 : 1.2)
    
    func cloneGuideFromJiggle() {
        jiggleDocument.cloneGuideFromJiggle()
    }
    func cloneGuideShrinkingSelected() {
        jiggleDocument.cloneGuideShrinkingSelected()
    }
    func doubleGuidePoints() {
        jiggleDocument.doubleGuidePoints()
    }
    func doubleJigglePoints() {
        jiggleDocument.doubleJigglePoints()
    }
    func insertGuidePointAfter() {
        jiggleDocument.insertGuidePointAfter()
    }
    func insertGuidePointBefore() {
        jiggleDocument.insertGuidePointBefore()
    }
    func insertJigglePointAfter() {
        jiggleDocument.insertJigglePointAfter()
    }
    func insertJigglePointBefore() {
        jiggleDocument.insertJigglePointBefore()
    }
    func resetAllGuidePointTans() {
        jiggleDocument.resetAllGuidePointTans()
    }
    func resetAllJigglePointTans() {
        jiggleDocument.resetAllJigglePointTans()
    }
    func resetPreciseRotation() {
        jiggleDocument.resetPreciseRotation()
    }
    
    func isAnimatingTouchArea(touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        switch touchTargetTouchSource {
        case .preciseMagnifiedBox:
            if isResetPreciseMagnifiedBoxActive {
                return true
            }
        case .preciseDistantBox:
            if isResetPreciseDistantBoxActive {
                return true
            }
        case .normalBox:
            if isResetZoomActive {
                return true
            }
        }
        return false
    }
    
    @MainActor func animatePreciseBoxFromSomethingChanged() {
        if jiggleScene.isPreciseTransitionActiveEnter { return }
        if jiggleScene.isPreciseTransitionActiveExit { return }
        if isVideoExportEnabled { return }
        if isVideoRecordEnabled { return }
        if isZoomEnabled { return }
        if jiggleDocument.isJoyPadTargetLocked { return }
        if isDisplayTransitionActive { return }
        
        if isPrecisePointsEnabled {
            
            var isAnyTouchActive = false
            // Touches and gestures
            
            if jiggleDocument.selectedWeightCenterTouch !== nil {
                isAnyTouchActive = true
            }
            if jiggleDocument.selectedJiggleControlPointTouch !== nil {
                isAnyTouchActive = true
            }
            if jiggleDocument.selectedJiggleControlPointTanTouch !== nil {
                isAnyTouchActive = true
            }
            if jiggleDocument.selectedGuideControlPointTouch !== nil {
                isAnyTouchActive = true
            }
            if jiggleDocument.selectedGuideControlPointTanTouch !== nil {
                isAnyTouchActive = true
            }
            if jiggleDocument.selectedJiggleCenterTouch !== nil {
                isAnyTouchActive = true
            }
            
            if isAnyTouchActive {
                print("*** TOUCH ACTIVE *** NOT ANIMATING ZOOM BOX...")
            }
            
            if let jiggleViewController = ApplicationController.shared.jiggleViewController {
                if jiggleViewController.toolAction !== nil {
                    print("[$$$$$$] There is some tool action; so not animating...")
                    return
                }
            }
            
            print("[$$$$$$] animatePreciseBoxFromSomethingChanged => About To Execute!!!")
            
            switch jiggleDocument.documentMode {
            case .edit:
                if jiggleDocument.isGuidesEnabled {
                    if isGraphMode == false {
                        switch jiggleDocument.weightMode {
                        case .points:
                            _animateMagnifiedBox()
                            _animateDistantBox()
                        case .guides:
                            break
                        }
                    }
                } else {
                    switch jiggleDocument.editMode {
                    case .jiggles:
                        break
                    case .points:
                        _animateMagnifiedBox()
                        _animateDistantBox()
                    }
                }
            case .view:
                break
            }
        }
    }
    
    @MainActor func attemptGuideAffinePanBegan(center: Math.Point,
                                               touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        jiggleDocument.attemptGuideAffinePanBegan(center: center,
                                                  displayMode: displayMode,
                                                  isGraphEnabled: isGraphEnabled,
                                                  touchTargetTouchSource: touchTargetTouchSource,
                                                  isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptGuideAffinePanMoved(center: Math.Point) -> Bool {
        jiggleDocument.attemptGuideAffinePanMoved(center: center,
                                                  displayMode: displayMode,
                                                  isGraphEnabled: isGraphEnabled,
                                                  isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptGuideAffinePanEnded(center: Math.Point) {
        jiggleDocument.attemptGuideAffinePanEnded(center: center)
    }
    
    @MainActor func attemptGuideAffinePinchBegan(center: Point,
                                                 scale: Float,
                                                 touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        jiggleDocument.attemptGuideAffinePinchBegan(center: center,
                                                    scale: scale,
                                                    displayMode: displayMode,
                                                    isGraphEnabled: isGraphEnabled,
                                                    touchTargetTouchSource: touchTargetTouchSource,
                                                    isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptGuideAffinePinchMoved(center: Point,
                                                 scale: Float) -> Bool {
        jiggleDocument.attemptGuideAffinePinchMoved(center: center,
                                                    scale: scale,
                                                    displayMode: displayMode,
                                                    isGraphEnabled: isGraphEnabled,
                                                    isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptGuideAffinePinchEnded(center: Point, scale: Float) {
        jiggleDocument.attemptGuideAffinePinchEnded(center: center,
                                                    scale: scale)
    }
    
    @MainActor func attemptGuideAffineRotateBegan(center: Point,
                                                  rotation: Float,
                                                  touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        jiggleDocument.attemptGuideAffineRotateBegan(center: center,
                                                     rotation: rotation,
                                                     displayMode: displayMode,
                                                     isGraphEnabled: isGraphEnabled,
                                                     touchTargetTouchSource: touchTargetTouchSource,
                                                     isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptGuideAffineRotateMoved(center: Point,
                                                  rotation: Float) -> Bool {
        jiggleDocument.attemptGuideAffineRotateMoved(center: center,
                                                     rotation: rotation,
                                                     displayMode: displayMode,
                                                     isGraphEnabled: isGraphEnabled,
                                                     isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptGuideAffineRotateEnded(center: Point,
                                                  rotation: Float) {
        jiggleDocument.attemptGuideAffineRotateEnded(center: center,
                                                     rotation: rotation)
    }
    
    
    
    
    
    
    
    @MainActor func attemptJiggleAffinePanBegan(center: Math.Point,
                                                touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        
        jiggleDocument.attemptJiggleAffinePanBegan(center: center,
                                                   displayMode: displayMode,
                                                   isGraphEnabled: isGraphEnabled,
                                                   touchTargetTouchSource: touchTargetTouchSource,
                                                   isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptJiggleAffinePanMoved(center: Math.Point) -> Bool {
        jiggleDocument.attemptJiggleAffinePanMoved(center: center,
                                                   displayMode: displayMode,
                                                   isGraphEnabled: isGraphEnabled,
                                                   isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptJiggleAffinePanEnded(center: Math.Point) {
        jiggleDocument.attemptJiggleAffinePanEnded(center: center)
    }
    
    @MainActor func attemptJiggleAffinePinchBegan(center: Point,
                                                  scale: Float,
                                                  touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        jiggleDocument.attemptJiggleAffinePinchBegan(center: center,
                                                     scale: scale,
                                                     displayMode: displayMode,
                                                     isGraphEnabled: isGraphEnabled,
                                                     touchTargetTouchSource: touchTargetTouchSource,
                                                     isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptJiggleAffinePinchMoved(center: Point,
                                                  scale: Float) -> Bool {
        jiggleDocument.attemptJiggleAffinePinchMoved(center: center,
                                                     scale: scale,
                                                     displayMode: displayMode,
                                                     isGraphEnabled: isGraphEnabled,
                                                     isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptJiggleAffinePinchEnded(center: Point, scale: Float) {
        jiggleDocument.attemptJiggleAffinePinchEnded(center: center,
                                                     scale: scale)
    }
    
    @MainActor func attemptJiggleAffineRotateBegan(center: Point,
                                                   rotation: Float,
                                                   touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        jiggleDocument.attemptJiggleAffineRotateBegan(center: center,
                                                      rotation: rotation,
                                                      displayMode: displayMode,
                                                      isGraphEnabled: isGraphEnabled,
                                                      touchTargetTouchSource: touchTargetTouchSource,
                                                      isPrecise: isRenderingPrecise)
        
    }
    
    @MainActor func attemptJiggleAffineRotateMoved(center: Point,
                                                   rotation: Float) -> Bool {
        jiggleDocument.attemptJiggleAffineRotateMoved(center: center,
                                                      rotation: rotation,
                                                      displayMode: displayMode,
                                                      isGraphEnabled: isGraphEnabled,
                                                      isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptJiggleAffineRotateEnded(center: Point, rotation: Float) {
        jiggleDocument.attemptJiggleAffineRotateEnded(center: center,
                                                      rotation: rotation)
    }
    
    @MainActor func notifyPreciseSelectionTargetWasTouched(source: TouchTargetTouchSource) {
        
        print("**** TT-DOWN **** source = \(source)")
        
        switch source {
        case .preciseMagnifiedBox:
            //animatePreciseBoxFromSomethingChanged()
            break
        case .preciseDistantBox:
            //animatePreciseBoxFromSomethingChanged()
            break
        case .normalBox:
            break
        }
    }
    
    @MainActor func notifyPreciseSelectionTargetWasReleased(source: TouchTargetReleaseSource) {
        
        
        print("**** TT-UPP **** source = \(source)")
        
        switch source {
        case .internalCancelAction:
            break
        case .gestureHandOverZoomModeCancel:
            break
        case .gestureHandOverPreciseMagnifiedBoxCancel:
            break
        case .gestureHandOverPreciseDistantBoxCancel:
            break
        case .gestureHandOverNormalBoxCancel:
            break
        case .gestureMovementTriggeredCancel:
            break
        case .touchesEndedNormalBox:
            break
        case .touchesEndedPreciseMagnifiedBox:
            animatePreciseBoxFromSomethingChanged()
        case .touchesEndedPreciseDistantBox:
            animatePreciseBoxFromSomethingChanged()
        case .usingGestureCancellingTouches:
            break
        case .usingDragCancellingGestures:
            break
        }
    }
    
    @MainActor func cancelAllTouchesInternal() {
        
    }
    
    @MainActor func shouldAnimateMagnifiedBox() -> Bool {
        if jiggleScene.gestureIsTrippedZoomAlongSidePreciseMagnified {
            print("[Zoom] NOT Animate, gesturing...")
            return false
        }
        
        if jiggleScene.gestureIsTrippedZoomAlongSidePreciseDistant {
            print("[Zoom] NOT Animate, gesturing...")
            return false
        }
        
        if (jiggleScene.isPreciseTransitionActiveExit == true) || (jiggleScene.isPreciseTransitionActiveEnter == true) {
            print("[Zoom] NOT Animate, animating in or out...")
            return false
        }
        
        return true
    }
    
    @MainActor func shouldAnimateWideBox() -> Bool {
        
        if (jiggleScene.isPreciseTransitionActiveExit == true) || (jiggleScene.isPreciseTransitionActiveEnter == true) {
            print("[Wide] NOT Animate, animating in or out...")
            return false
        }
        
        return true
    }
    
    func executeAnimateMagnifiedBox(point: Math.Point) {
        
        let zoomScale = jiggleScene.getPreciseMagnifiedScale()
        let zoomRotation = jiggleScene.preciseMagnifiedRotation
        
        print("[SKK] Magnified: \(zoomScale)")
        
        resetPreciseMagnifiedBoxStartX = jiggleScene.preciseMagnifiedTranslation.x
        resetPreciseMagnifiedBoxStartY = jiggleScene.preciseMagnifiedTranslation.y
        resetPreciseMagnifiedBoxStartScale = jiggleScene.preciseMagnifiedScale
        resetPreciseMagnifiedBoxStartRotation = jiggleScene.preciseMagnifiedRotation
        
        let boxCenterX = jiggleScene.preciseContentFrameMagnifiedX + jiggleScene.preciseContentFrameMagnifiedWidth * 0.5
        let boxCenterY = jiggleScene.preciseContentFrameMagnifiedY + jiggleScene.preciseContentFrameMagnifiedHeight * 0.5
        
        let transform = Self.computeTransform(documentWidth2: jiggleDocument.widthNaturalized_2,
                                              documentHeight2: jiggleDocument.heightNaturalized_2,
                                              centerX: boxCenterX,
                                              centerY: boxCenterY,
                                              pointX: point.x,
                                              pointY: point.y,
                                              scale: zoomScale,
                                              rotation: zoomRotation)
        
        resetPreciseMagnifiedBoxEndX = transform.x
        resetPreciseMagnifiedBoxEndY = transform.y
        resetPreciseMagnifiedBoxEndScale = transform.scale
        resetPreciseMagnifiedBoxEndRotation = transform.rotation
        
        isResetPreciseMagnifiedBoxActive = true
        resetPreciseMagnifiedBoxAnimationTimeElapsed = 0.0
        
        print("Precise Mag X-Tion, STARTED!")
    }
    
    func executeAnimateDistantBox(point: Math.Point) {
        
        let zoomScale = jiggleScene.getPreciseDistantScale()
        let zoomRotation = jiggleScene.preciseDistantRotation
        
        resetPreciseDistantBoxStartX = jiggleScene.preciseDistantTranslation.x
        resetPreciseDistantBoxStartY = jiggleScene.preciseDistantTranslation.y
        resetPreciseDistantBoxStartScale = jiggleScene.preciseDistantScale
        resetPreciseDistantBoxStartRotation = jiggleScene.preciseDistantRotation
        
        let boxCenterX = jiggleScene.preciseContentFrameDistantX + jiggleScene.preciseContentFrameDistantWidth * 0.5
        let boxCenterY = jiggleScene.preciseContentFrameDistantY + jiggleScene.preciseContentFrameDistantHeight * 0.5
        
        let transform = Self.computeTransform(documentWidth2: jiggleDocument.widthNaturalized_2,
                                              documentHeight2: jiggleDocument.heightNaturalized_2,
                                              centerX: boxCenterX,
                                              centerY: boxCenterY,
                                              pointX: point.x,
                                              pointY: point.y,
                                              scale: zoomScale,
                                              rotation: zoomRotation)
        
        resetPreciseDistantBoxEndX = transform.x
        resetPreciseDistantBoxEndY = transform.y
        resetPreciseDistantBoxEndScale = transform.scale
        resetPreciseDistantBoxEndRotation = transform.rotation
        
        isResetPreciseDistantBoxActive = true
        resetPreciseDistantBoxAnimationTimeElapsed = 0.0
        print("Precise Distant X-Tion, STARTED!")
        
    }
    
    private func _animateMagnifiedBox() {
        let preciseZoomJiggleData = getPreciseZoomJiggleData(isGuideMode: jiggleDocument.isGuidesEnabled)
        if preciseZoomJiggleData.isValid {
            let point = Point(x: preciseZoomJiggleData.centerX,
                              y: preciseZoomJiggleData.centerY)
            executeAnimateMagnifiedBox(point: point)
        }
    }
    
    
    private func _animateDistantBox() {
        let preciseZoomJiggleData = getPreciseZoomJiggleData(isGuideMode: jiggleDocument.isGuidesEnabled)
        if preciseZoomJiggleData.isValid {
            let point = Point(x: preciseZoomJiggleData.centerX,
                              y: preciseZoomJiggleData.centerY)
            executeAnimateDistantBox(point: point)
        }
    }
    
    
    @MainActor static let joyPadNudgeFactor: Float = Device.isPad ? 0.44 : 0.36
    
    @MainActor func handleLineThicknessDidChange() {
        jiggleDocument.handleLineThicknessDidChange(isPrecise: isRenderingPrecise)
    }
    
    @MainActor func handlePreciseScaleSliderDidStart(value: Float) {
        jiggleScene.handlePreciseScaleSliderDidStart(value: value)
    }
    
    @MainActor func handlePreciseScaleSliderDidUpdate(value: Float) {
        jiggleScene.handlePreciseScaleSliderDidUpdate(value: value)
    }
    
    @MainActor func handlePreciseScaleSliderDidFinish(value: Float) {
        jiggleScene.handlePreciseScaleSliderDidFinish(value: value)
    }
    
    var isPrecisePointsEnabled = false
    
    //weak var preciseJiggle: Jiggle?
    //weak var preciseGuide: Guide?
    //weak var preciseJiggleControlPoint: JiggleControlPoint?
    //weak var preciseGuideControlPoint: GuideControlPoint?
    //var preciseTanType = TanTypeOrNone.none
    
    
    /*
     @MainActor func getPreciseWideJiggleData() -> JiggleFrameData {
     let defaultSize = min(jiggleDocument.widthNaturalized, jiggleDocument.heightNaturalized) * 0.25
     if let jiggle = jiggleDocument.mostRecentSelectedJiggle {
     if jiggle.outlineJiggleWeightPointCount <= 0 {
     let defaultSize_2 = defaultSize * 0.5
     return JiggleFrameData(centerX: jiggle.center.x,
     centerY: jiggle.center.y,
     minX: jiggle.center.x - defaultSize_2,
     minY: jiggle.center.y - defaultSize_2,
     maxX: jiggle.center.x + defaultSize_2,
     maxY: jiggle.center.y + defaultSize_2)
     } else {
     var x = jiggle.outlineJiggleWeightPoints[0].x
     var y = jiggle.outlineJiggleWeightPoints[0].y
     var minX = x
     var maxX = x
     var minY = y
     var maxY = y
     for outlineJiggleWeightPointIndex in 0..<jiggle.outlineJiggleWeightPointCount {
     x = jiggle.outlineJiggleWeightPoints[outlineJiggleWeightPointIndex].x
     y = jiggle.outlineJiggleWeightPoints[outlineJiggleWeightPointIndex].y
     if x < minX { minX = x }
     if x > maxX { maxX = x }
     if y < minY { minY = y }
     if y > maxY { maxY = y }
     }
     let centerX = minX + (maxX - minX) * 0.5
     let centerY = minY + (maxY - minY) * 0.5
     let paddingX = jiggleDocument.widthNaturalized_2 * JiggleScene.preciseModeWideViewExtraPaddingFactor
     let paddingY = jiggleDocument.heightNaturalized_2 * JiggleScene.preciseModeWideViewExtraPaddingFactor
     return JiggleFrameData(centerX: centerX,
     centerY: centerY,
     minX: minX - paddingX,
     minY: minY - paddingY,
     maxX: maxX + paddingX,
     maxY: maxY + paddingY)
     }
     } else {
     let defaultSize_2 = defaultSize * 0.5
     return JiggleFrameData(centerX: jiggleDocument.widthNaturalized_2,
     centerY: jiggleDocument.heightNaturalized_2,
     minX: jiggleDocument.widthNaturalized_2 - defaultSize_2,
     minY: jiggleDocument.heightNaturalized_2 - defaultSize_2,
     maxX: jiggleDocument.widthNaturalized_2 + defaultSize_2,
     maxY: jiggleDocument.heightNaturalized_2 + defaultSize_2)
     }
     }
     */
    
    func getPreciseZoomJiggleData(isGuideMode: Bool) -> JigglePointData {
        if let jiggle = jiggleDocument.mostRecentSelectedJiggle {
            if isGuideMode {
                if let guide = jiggleDocument.mostRecentSelectedGuide {
                    if let guideControlPoint = jiggleDocument.mostRecentSelectedGuideControlPoint {
                        switch jiggleDocument.pointSelectionMode {
                        case .points:
                            var point = guideControlPoint.point
                            point = guide.transformPoint(point: point)
                            point = jiggle.transformPoint(point: point)
                            return JigglePointData(centerX: point.x,
                                                   centerY: point.y,
                                                   isValid: true)
                        default:
                            switch guideControlPoint.selectedTanType {
                            case .none:
                                var point = guideControlPoint.point
                                point = guide.transformPoint(point: point)
                                point = jiggle.transformPoint(point: point)
                                return JigglePointData(centerX: point.x,
                                                       centerY: point.y,
                                                       isValid: true)
                            case .in:
                                var tanHandle = guideControlPoint.getTanHandleIn()
                                tanHandle = guide.transformPoint(point: tanHandle)
                                tanHandle = jiggle.transformPoint(point: tanHandle)
                                return JigglePointData(centerX: tanHandle.x,
                                                       centerY: tanHandle.y,
                                                       isValid: true)
                            case .out:
                                var tanHandle = guideControlPoint.getTanHandleOut()
                                tanHandle = guide.transformPoint(point: tanHandle)
                                tanHandle = jiggle.transformPoint(point: tanHandle)
                                return JigglePointData(centerX: tanHandle.x,
                                                       centerY: tanHandle.y,
                                                       isValid: true)
                            }
                        }
                    }
                }
            } else {
                if let jiggleControlPoint = jiggleDocument.mostRecentSelectedJiggleControlPoint {
                    switch jiggleDocument.pointSelectionMode {
                    case .points:
                        var point = jiggleControlPoint.point
                        point = jiggle.transformPoint(point: point)
                        return JigglePointData(centerX: point.x,
                                               centerY: point.y,
                                               isValid: true)
                    default:
                        switch jiggleControlPoint.selectedTanType {
                        case .none:
                            var point = jiggleControlPoint.point
                            point = jiggle.transformPoint(point: point)
                            return JigglePointData(centerX: point.x,
                                                   centerY: point.y,
                                                   isValid: true)
                        case .in:
                            var tanHandle = jiggleControlPoint.getTanHandleIn()
                            tanHandle = jiggle.transformPoint(point: tanHandle)
                            return JigglePointData(centerX: tanHandle.x,
                                                   centerY: tanHandle.y,
                                                   isValid: true)
                        case .out:
                            var tanHandle = jiggleControlPoint.getTanHandleOut()
                            tanHandle = jiggle.transformPoint(point: tanHandle)
                            return JigglePointData(centerX: tanHandle.x,
                                                   centerY: tanHandle.y,
                                                   isValid: true)
                        }
                    }
                }
            }
        }
        
        return JigglePointData(centerX: jiggleDocument.widthNaturalized_2,
                               centerY: jiggleDocument.heightNaturalized_2,
                               isValid: false)
    }
    
    static func computeTransform(documentWidth2: Float,
                                 documentHeight2: Float,
                                 centerX: Float,
                                 centerY: Float,
                                 pointX: Float,
                                 pointY: Float,
                                 scale: Float,
                                 rotation: Float) -> WorldTransform {
        var convertedX = centerX
        var convertedY = centerY
        if rotation != 0.0 {
            let distanceSquared = convertedX * convertedX + convertedY * convertedY
            let distance: Float
            if distanceSquared > Math.epsilon {
                distance = sqrtf(Float(distanceSquared))
                convertedX /= distance
                convertedY /= distance
            } else {
                distance = 0.0
            }
            let pivotRotation = -rotation - atan2f(-convertedX, -convertedY)
            convertedX = sinf(Float(pivotRotation)) * distance
            convertedY = -cosf(Float(pivotRotation)) * distance
        }
        if scale != 1.0 {
            convertedX /= scale
            convertedY /= scale
        }
        convertedX += documentWidth2
        convertedX -= pointX
        convertedY += documentHeight2
        convertedY -= pointY
        if scale != 1.0 {
            convertedX *= scale
            convertedY *= scale
        }
        if rotation != 0 {
            let distanceSquared = convertedX * convertedX + convertedY * convertedY
            let distance: Float
            if distanceSquared > Math.epsilon {
                distance = sqrtf(Float(distanceSquared))
                convertedX /= distance
                convertedY /= distance
            } else {
                distance = 0.0
            }
            let pivotRotation = rotation - atan2f(-convertedX, -convertedY)
            convertedX = sinf(Float(pivotRotation)) * distance
            convertedY = -cosf(Float(pivotRotation)) * distance
        }
        return WorldTransform(x: convertedX,
                              y: convertedY,
                              scale: scale,
                              rotation: rotation)
    }
    
    @MainActor static func computeTransform(documentWidth2: Float,
                                            documentHeight2: Float,
                                            jigglePointData: JigglePointData,
                                            scale: Float,
                                            rotation: Float,
                                            frameX: Float,
                                            frameY: Float,
                                            frameWidth: Float,
                                            frameHeight: Float,
                                            frameCenterX: Float,
                                            frameCenterY: Float) -> WorldTransform {
        return computeTransform(documentWidth2: documentWidth2,
                                documentHeight2: documentHeight2,
                                centerX: frameCenterX,
                                centerY: frameCenterY,
                                pointX: jigglePointData.centerX,
                                pointY: jigglePointData.centerY,
                                scale: scale,
                                rotation: rotation)
    }
    
    /*
     @MainActor static func computeTransform(documentWidth2: Float,
     documentHeight2: Float,
     jiggleFrameData: JiggleFrameData,
     rotation: Float,
     frameX: Float,
     frameY: Float,
     frameWidth: Float,
     frameHeight: Float,
     frameCenterX: Float,
     frameCenterY: Float) -> WorldTransform {
     
     var frameWidth = frameWidth
     if frameWidth < 32.0 { frameWidth = 32.0 }
     
     var frameHeight = frameHeight
     if frameHeight < 32.0 { frameHeight = 32.0 }
     
     let rangeX = jiggleFrameData.maxX - jiggleFrameData.minX
     let rangeY = jiggleFrameData.maxY - jiggleFrameData.minY
     
     let scaleFactorX = rangeX / frameWidth
     let scaleFactorY = rangeY / frameHeight
     let appScale = max(scaleFactorX, scaleFactorY)
     let scale = (1.0 / appScale)
     
     return computeTransform(documentWidth2: documentWidth2,
     documentHeight2: documentHeight2,
     centerX: frameCenterX,
     centerY: frameCenterY,
     pointX: jiggleFrameData.centerX,
     pointY: jiggleFrameData.centerY,
     scale: scale,
     rotation: rotation)
     }
     */
    
    //@MainActor
    func isHandOverToAutoZoomPossible(points: [Point],
                                      touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        if isVideoExportEnabled { return false }
        if isVideoRecordEnabled { return false }
        if isZoomEnabled { return false }
        if isGraphEnabled { return false }
        if isPrecisePointsEnabled { return false }
        if jiggleDocument.isHandOverToAutoZoomPossible(points: points,
                                                       touchTargetTouchSource: touchTargetTouchSource) {
            return true
        } else {
            return false
        }
    }
    
    static let preciseScaleAmountUserMin = Float(0.0)
    static let preciseScaleAmountUserMax = Float(100.0)
    static let preciseScaleAmountUserDefault = Float(64.0)
    
    static let preciseScaleAmountMagnifiedMin = Float(2.0)
    static let preciseScaleAmountMagnifiedMax = Float(8.0)
    
    
    static let preciseScaleAmountDistantMin = preciseScaleAmountMagnifiedMin * 0.2
    static let preciseScaleAmountDistantMax = preciseScaleAmountMagnifiedMax * 0.2

    
    
    
    
    /*
     var isPrecisePointsEnabled = true
     var isPrecisePointsVisible = false
     @MainActor var isPrecisePointsShowing: Bool {
     if isPrecisePointsVisible {
     if isPrecisePointsPossible {
     if let selectedJiggle = jiggleDocument.getSelectedJiggle() {
     var isShowing = false
     if selectedJiggle.isShowingMeshEditStandard {
     isShowing = true
     }
     if selectedJiggle.isShowingMeshEditWeights {
     isShowing = true
     }
     return isShowing
     
     } else {
     return false
     }
     } else {
     return false
     }
     } else {
     return false
     }
     }
     
     @MainActor var isPrecisePointsPossible: Bool {
     if isPrecisePointsEnabled {
     
     if isVideoExportEnabled { return false }
     if isVideoRecordEnabled { return false }
     if isZoomEnabled { return false }
     
     
     } else {
     return false
     }
     }
     */
    
    //var isTimeLinePage2Enabled = false
    
    var selectedTimeLineSwatch = Swatch.scale
    
    @MainActor func showErrorAlertIfApplicable(attemptDeleteGuideResult: AttemptDeleteGuideResult) {
        switch attemptDeleteGuideResult {
        case .invalid:
            break
        case .success:
            break
        case .selectedJiggleRequired:
            MessageBoxes.showSelectedJiggleRequired()
        case .selectedGuideRequired:
            MessageBoxes.showSelectedGuideRequired()
        }
    }
    
    @MainActor func showErrorAlertIfApplicable(attemptCreateGuidePointResult: AttemptCreateGuidePointResult) {
        switch attemptCreateGuidePointResult {
        case .invalid:
            break
        case .success:
            break
        case .selectedJiggleRequired:
            MessageBoxes.showSelectedJiggleRequired()
        case .selectedGuideRequired:
            MessageBoxes.showSelectedGuideRequired()
        case .guidePointCountOverflow:
            MessageBoxes.showGuidePointCountOverflow()
        }
    }
    
    @MainActor func showErrorAlertIfApplicable(attemptDeleteGuidePointResult: AttemptDeleteGuidePointResult) {
        switch attemptDeleteGuidePointResult {
        case .invalid:
            break
        case .success:
            break
        case .selectedJiggleRequired:
            MessageBoxes.showSelectedJiggleRequired()
        case .selectedGuideRequired:
            MessageBoxes.showSelectedGuideRequired()
        case .selectedGuidePointRequired:
            MessageBoxes.showSelectedGuidePointRequired()
        case .guidePointCountUnderflow:
            MessageBoxes.showGuidePointCountUnderflow()
        }
    }
    
    @MainActor func showErrorAlertIfApplicable(attemptCreateJigglePointResult: AttemptCreateJigglePointResult) {
        switch attemptCreateJigglePointResult {
        case .invalid:
            break
        case .success:
            break
        case .selectedJiggleRequired:
            MessageBoxes.showSelectedJiggleRequired()
        case .jigglePointCountOverflow:
            MessageBoxes.showJigglePointCountOverflow()
        }
    }
    
    @MainActor func showErrorAlertIfApplicable(attemptDeleteJiggleResult: AttemptDeleteJiggleResult) {
        switch attemptDeleteJiggleResult {
        case .invalid:
            break
        case .success:
            break
        case .selectedJiggleRequired:
            MessageBoxes.showSelectedJiggleRequired()
        }
    }
    
    @MainActor func showErrorAlertIfApplicable(attemptDeleteJigglePointResult: AttemptDeleteJigglePointResult) {
        switch attemptDeleteJigglePointResult {
        case .invalid:
            break
        case .success:
            break
        case .selectedJiggleRequired:
            MessageBoxes.showSelectedJiggleRequired()
        case .selectedJigglePointRequired:
            MessageBoxes.showSelectedJigglePointRequired()
        case .jigglePointCountUnderflow:
            MessageBoxes.showJigglePointCountUnderflow()
        }
    }
    
    @MainActor func showErrorAlertIfApplicable(attemptCreateGuideResult: AttemptCreateGuideResult) {
        switch attemptCreateGuideResult {
        case .invalid:
            break
        case .success:
            break
        case .selectedJiggleRequired:
            MessageBoxes.showSelectedJiggleRequired()
        case .selectedGuideRequired:
            MessageBoxes.showSelectedGuideRequired()
        case .guideCountOverflow:
            MessageBoxes.showGuideCountOverflow()
        case .guidePointCountOverflow:
            MessageBoxes.showGuidePointCountOverflow()
        case .guidePointCountUnderflow:
            MessageBoxes.showGuidePointCountUnderflow()
        case .drawGuideTooSmall:
            MessageBoxes.showDrawingTooSmallError()
            break
        }
    }
    
    @MainActor func showErrorAlertIfApplicable(attemptCreateJiggleResult: AttemptCreateJiggleResult) {
        switch attemptCreateJiggleResult {
        case .invalid:
            break
        case .success:
            break
        case .brokenJiggle:
            MessageBoxes.showJiggleBroken()
        case .selectedJiggleRequired:
            MessageBoxes.showSelectedJiggleRequired()
        case .jiggleCountOverflow:
            MessageBoxes.showJiggleCountOverflow()
        case .jigglePointCountOverflow:
            MessageBoxes.showJigglePointCountOverflow()
        case .jigglePointCountUnderflow:
            MessageBoxes.showJigglePointCountUnderflow()
        case .drawJiggleTooSmall:
            MessageBoxes.showDrawingTooSmallError()
            break
        }
    }
    
    private var _graphDraggingStatus = false
    func getGraphDraggingStatus() -> Bool {
        return _graphDraggingStatus
    }
    
    @MainActor private func _calculateGraphDraggingStatus() -> Bool {
        if isVideoExportEnabled { return false }
        if isVideoRecordEnabled { return false }
        if isZoomEnabled { return false }
        
        guard let jiggleViewController = ApplicationController.shared.jiggleViewController else {
            return false
        }
        
        switch jiggleDocument.documentMode {
        case .edit:
            if jiggleDocument.isGuidesEnabled {
                if isGraphEnabled {
                    let graphView: GraphView
                    if Device.isPad {
                        graphView = jiggleViewController.padDraggableMenu.standardContainerView.graphContainerView.graphView
                    } else {
                        graphView = jiggleViewController.phoneTopMenu.standardContainerView.graphContainerView.graphView
                    }
                    if graphView.selectedWeightCurveControlPointTouch !== nil {
                        return true
                    }
                    if graphView.selectedWeightCurveControlTanTouch !== nil {
                        return true
                    }
                    return false
                } else {
                    return false
                }
            } else {
                return false
            }
        case .view:
            return false
        }
    }
    
    @MainActor func graphDragNotifyStarted() {
        print("graphDragNotifyStarted")
        
        _graphDraggingStatus = _calculateGraphDraggingStatus()
        print("_graphDraggingStatus = \(_graphDraggingStatus)")
        if let toolInterfaceViewModel = toolInterfaceViewModel {
            toolInterfaceViewModel.handleGraphDraggedJigglesDidChange()
        }
    }
    
    @MainActor func graphDragNotifyFinished() {
        print("graphDragNotifyFinished")
        
        
        _graphDraggingStatus = _calculateGraphDraggingStatus()
        
        print("_graphDraggingStatus = \(_graphDraggingStatus)")
        if let toolInterfaceViewModel = toolInterfaceViewModel {
            toolInterfaceViewModel.handleGraphDraggedJigglesDidChange()
        }
    }
    
    private var _timeLineDraggingStatus = false
    @MainActor func getTimeLineDraggingStatus() -> Bool {
        return _timeLineDraggingStatus
    }
    
    @MainActor private func _calculateTimeLineDraggingStatus() -> Bool {
        if isVideoExportEnabled { return false }
        if isVideoRecordEnabled { return false }
        if isZoomEnabled { return false }
        
        guard let jiggleViewController = ApplicationController.shared.jiggleViewController else {
            return false
        }
        
        switch jiggleDocument.documentMode {
        case .edit:
            return false
        case .view:
            if jiggleDocument.isAnimationLoopsEnabled {
                
                if jiggleDocument.isTimeLineEnabled {
                    
                    let timeLineView: TimeLineView
                    if Device.isPad {
                        timeLineView = jiggleViewController.padDraggableMenu.standardContainerView.timeLineContainerView.timeLineView
                    } else {
                        timeLineView = jiggleViewController.phoneTopMenu.standardContainerView.timeLineContainerView.timeLineView
                    }
                    if timeLineView.selectedTimeLineControlPointTouch !== nil {
                        return true
                    }
                    if timeLineView.selectedTimeLineControlTanTouch !== nil {
                        return true
                    }
                    return false
                } else {
                    return false
                }
            } else {
                return false
            }
        }
    }
    
    @MainActor func timeLineDragNotifyStarted() {
        print("timeLineDragNotifyStarted")
        
        _timeLineDraggingStatus = _calculateTimeLineDraggingStatus()
        print("_timeLineDraggingStatus = \(_timeLineDraggingStatus)")
        if let toolInterfaceViewModel = toolInterfaceViewModel {
            toolInterfaceViewModel.handleTimeLineDraggedJigglesDidChange()
        }
    }
    
    
    @MainActor func timeLineDragNotifyFinished() {
        print("timeLineDragNotifyFinished")
        
        
        _timeLineDraggingStatus = _calculateTimeLineDraggingStatus()
        
        print("_timeLineDraggingStatus = \(_timeLineDraggingStatus)")
        if let toolInterfaceViewModel = toolInterfaceViewModel {
            toolInterfaceViewModel.handleTimeLineDraggedJigglesDidChange()
        }
    }
    
    
    
    
    private var _continuousDraggingStatus = false
    @MainActor func getContinuousDraggingStatus() -> Bool {
        return _continuousDraggingStatus
    }
    
    @MainActor private func _calculateContinuousDraggingStatus() -> Bool {
        if isVideoExportEnabled { return false }
        if isVideoRecordEnabled { return false }
        if isZoomEnabled { return false }
        
        switch jiggleDocument.documentMode {
        case .edit:
            return false
        case .view:
            if jiggleDocument.isAnimationLoopsEnabled {
                return false
            }
            if jiggleDocument.isAnimationContinuousEnabled {
                
                // Is any jiggle being dragged by touch?
                for jiggleIndex in 0..<jiggleDocument.jiggleCount {
                    let jiggle = jiggleDocument.jiggles[jiggleIndex]
                    if jiggle.isCaptureActiveContinuous {
                        return true
                    }
                }
                return false
                
            } else {
                return false
            }
        }
    }
    
    @MainActor func continuousRealizeJiggleWillStartGrab(jiggle: Jiggle) {
        jiggle.snapShotContinuousDragHistory()
    }
    
    @MainActor func continuousRealizeJiggleDidStartGrab(jiggle: Jiggle) {
        _continuousDraggingStatus = _calculateContinuousDraggingStatus()
        if let toolInterfaceViewModel = toolInterfaceViewModel {
            toolInterfaceViewModel.handleContinuousDraggedJigglesDidChange()
        }
    }
    
    @MainActor func continuousRealizeJiggleDidStopGrab(jiggle: Jiggle) {
        if let jiggleIndex = jiggleDocument.getJiggleIndex(jiggle) {
            let startData = ContinuousAttributeDataUserAll(duration: jiggle._snapShotContinuousDuration,
                                                           angle: jiggle._snapShotContinuousAngle,
                                                           power: jiggle._snapShotContinuousPower,
                                                           swoop: jiggle._snapShotContinuousSwoop,
                                                           frameOffset: jiggle._snapShotContinuousFrameOffset,
                                                           startScale: jiggle._snapShotContinuousStartScale,
                                                           endScale: jiggle._snapShotContinuousEndScale,
                                                           startRotation: jiggle._snapShotContinuousStartRotation,
                                                           endRotation: jiggle._snapShotContinuousEndRotation)
            let startAttribute = ContinuousAttribute(jiggleIndex: jiggleIndex,
                                                     continuousAttributeType: .continuousAll,
                                                     continuousAttributeTypeWithData: .continuousAll(startData))
            let endData = ContinuousAttributeDataUserAll(duration: jiggle.continuousDuration,
                                                         angle: jiggle.continuousAngle,
                                                         power: jiggle.continuousPower,
                                                         swoop: jiggle.continuousSwoop,
                                                         frameOffset: jiggle.continuousFrameOffset,
                                                         startScale: jiggle.continuousStartScale,
                                                         endScale: jiggle.continuousEndScale,
                                                         startRotation: jiggle.continuousStartRotation,
                                                         endRotation: jiggle.continuousEndRotation)
            let endAttribute = ContinuousAttribute(jiggleIndex: jiggleIndex,
                                                   continuousAttributeType: .continuousAll,
                                                   continuousAttributeTypeWithData: .continuousAll(endData))
            historyRecordContinuousAttributeOne(jiggleIndex: jiggleIndex,
                                                startAttribute: startAttribute,
                                                endAttribute: endAttribute)
        }
        
        _continuousDraggingStatus = _calculateContinuousDraggingStatus()
        if let toolInterfaceViewModel = toolInterfaceViewModel {
            toolInterfaceViewModel.handleContinuousDraggedJigglesDidChange()
        }
    }
    
    @MainActor func snapshotTimeLineHistoryForTimeLineModifyAll(jiggle: Jiggle) {
        if isAnimationLoopsAppliedToAll {
            jiggleDocument.snapShotLoopAttributesAll(attributeType: .timeLine,
                                                     selectedJiggleIndex: jiggleDocument.getJiggleIndex(jiggle),
                                                     selectedTimeLineSwatch: selectedTimeLineSwatch)
        } else {
            jiggleDocument.snapShotLoopAttributeOne(attributeType: .timeLine,
                                                    targetJiggleIndex: jiggleDocument.getJiggleIndex(jiggle),
                                                    selectedTimeLineSwatch: selectedTimeLineSwatch)
        }
    }
    
    @MainActor func snapshotTimeLineHistoryForOneSwatchAll(jiggle: Jiggle) {
        switch selectedTimeLineSwatch {
        case .x:
            jiggleDocument.snapShotLoopAttributesAll(attributeType: .timeLineSwatchX,
                                                     selectedJiggleIndex: jiggleDocument.getJiggleIndex(jiggle),
                                                     selectedTimeLineSwatch: selectedTimeLineSwatch)
        case .y:
            jiggleDocument.snapShotLoopAttributesAll(attributeType: .timeLineSwatchY,
                                                     selectedJiggleIndex: jiggleDocument.getJiggleIndex(jiggle),
                                                     selectedTimeLineSwatch: selectedTimeLineSwatch)
        case .scale:
            jiggleDocument.snapShotLoopAttributesAll(attributeType: .timeLineSwatchScale,
                                                     selectedJiggleIndex: jiggleDocument.getJiggleIndex(jiggle),
                                                     selectedTimeLineSwatch: selectedTimeLineSwatch)
        case .rotation:
            jiggleDocument.snapShotLoopAttributesAll(attributeType: .timeLineSwatchRotation,
                                                     selectedJiggleIndex: jiggleDocument.getJiggleIndex(jiggle),
                                                     selectedTimeLineSwatch: selectedTimeLineSwatch)
        }
    }
    
    @MainActor func snapshotTimeLineHistoryForOneSwatchSelected(jiggle: Jiggle) {
        switch selectedTimeLineSwatch {
        case .x:
            jiggleDocument.snapShotLoopAttributeOne(attributeType: .timeLineSwatchX,
                                                    targetJiggleIndex: jiggleDocument.getJiggleIndex(jiggle),
                                                    selectedTimeLineSwatch: selectedTimeLineSwatch)
        case .y:
            jiggleDocument.snapShotLoopAttributeOne(attributeType: .timeLineSwatchY,
                                                    targetJiggleIndex: jiggleDocument.getJiggleIndex(jiggle),
                                                    selectedTimeLineSwatch: selectedTimeLineSwatch)
        case .scale:
            jiggleDocument.snapShotLoopAttributeOne(attributeType: .timeLineSwatchScale,
                                                    targetJiggleIndex: jiggleDocument.getJiggleIndex(jiggle),
                                                    selectedTimeLineSwatch: selectedTimeLineSwatch)
        case .rotation:
            jiggleDocument.snapShotLoopAttributeOne(attributeType: .timeLineSwatchRotation,
                                                    targetJiggleIndex: jiggleDocument.getJiggleIndex(jiggle),
                                                    selectedTimeLineSwatch: selectedTimeLineSwatch)
        }
    }
    
    @MainActor func recordTimeLineHistoryForOneSwatch() {
        if jiggleDocument.snapShotLoopAttributeIsAppliedToAll {
            let startAttributes = jiggleDocument.snapShotLoopAttributesAll
            if startAttributes.count > 0 {
                switch startAttributes[0].loopAttributeTypeWithData {
                case .timeLine:
                    break
                case .timeLineFrameOffset:
                    break
                case .timeLineDuration:
                    break
                case .timeLineSwatchX(let timeLineSwatchDataStart):
                    jiggleDocument.snapShotLoopAttributesAll(attributeType: .timeLineSwatchX,
                                                             selectedJiggleIndex: jiggleDocument.snapShotLoopAttributesAllSelectedIndex,
                                                             selectedTimeLineSwatch: timeLineSwatchDataStart.selectedSwatch)
                    let endAttributes = jiggleDocument.snapShotLoopAttributesAll
                    if startAttributes.count == endAttributes.count {
                        historyRecordLoopAttributesAll(jiggleIndex: jiggleDocument.snapShotLoopAttributesAllSelectedIndex,
                                                       startAttributes: startAttributes,
                                                       endAttributes: endAttributes)
                    }
                case .timeLineSwatchY(let timeLineSwatchDataStart):
                    jiggleDocument.snapShotLoopAttributesAll(attributeType: .timeLineSwatchY,
                                                             selectedJiggleIndex: jiggleDocument.snapShotLoopAttributesAllSelectedIndex,
                                                             selectedTimeLineSwatch: timeLineSwatchDataStart.selectedSwatch)
                    let endAttributes = jiggleDocument.snapShotLoopAttributesAll
                    if startAttributes.count == endAttributes.count {
                        historyRecordLoopAttributesAll(jiggleIndex: jiggleDocument.snapShotLoopAttributesAllSelectedIndex,
                                                       startAttributes: startAttributes,
                                                       endAttributes: endAttributes)
                    }
                case .timeLineSwatchScale(let timeLineSwatchDataStart):
                    jiggleDocument.snapShotLoopAttributesAll(attributeType: .timeLineSwatchScale,
                                                             selectedJiggleIndex: jiggleDocument.snapShotLoopAttributesAllSelectedIndex,
                                                             selectedTimeLineSwatch: timeLineSwatchDataStart.selectedSwatch)
                    let endAttributes = jiggleDocument.snapShotLoopAttributesAll
                    if startAttributes.count == endAttributes.count {
                        historyRecordLoopAttributesAll(jiggleIndex: jiggleDocument.snapShotLoopAttributesAllSelectedIndex,
                                                       startAttributes: startAttributes,
                                                       endAttributes: endAttributes)
                    }
                case .timeLineSwatchRotation(let timeLineSwatchDataStart):
                    jiggleDocument.snapShotLoopAttributesAll(attributeType: .timeLineSwatchRotation,
                                                             selectedJiggleIndex: jiggleDocument.snapShotLoopAttributesAllSelectedIndex,
                                                             selectedTimeLineSwatch: timeLineSwatchDataStart.selectedSwatch)
                    let endAttributes = jiggleDocument.snapShotLoopAttributesAll
                    if startAttributes.count == endAttributes.count {
                        historyRecordLoopAttributesAll(jiggleIndex: jiggleDocument.snapShotLoopAttributesAllSelectedIndex,
                                                       startAttributes: startAttributes,
                                                       endAttributes: endAttributes)
                    }
                }
            }
        } else {
            if let startAttribute = jiggleDocument.snapShotLoopAttributeOne {
                switch startAttribute.loopAttributeTypeWithData {
                case .timeLine:
                    break
                case .timeLineFrameOffset:
                    break
                case .timeLineDuration:
                    break
                case .timeLineSwatchX(let timeLineSwatchDataStart):
                    jiggleDocument.snapShotLoopAttributeOne(attributeType: .timeLineSwatchX,
                                                            targetJiggleIndex: jiggleDocument.snapShotLoopAttributeOneTargetIndex,
                                                            selectedTimeLineSwatch: timeLineSwatchDataStart.selectedSwatch)
                    if let endAttribute = jiggleDocument.snapShotLoopAttributeOne {
                        historyRecordLoopAttributeOne(jiggleIndex: jiggleDocument.snapShotLoopAttributeOneTargetIndex,
                                                      startAttribute: startAttribute,
                                                      endAttribute: endAttribute)
                    }
                case .timeLineSwatchY(let timeLineSwatchDataStart):
                    jiggleDocument.snapShotLoopAttributeOne(attributeType: .timeLineSwatchY,
                                                            targetJiggleIndex: jiggleDocument.snapShotLoopAttributeOneTargetIndex,
                                                            selectedTimeLineSwatch: timeLineSwatchDataStart.selectedSwatch)
                    if let endAttribute = jiggleDocument.snapShotLoopAttributeOne {
                        historyRecordLoopAttributeOne(jiggleIndex: jiggleDocument.snapShotLoopAttributeOneTargetIndex,
                                                      startAttribute: startAttribute,
                                                      endAttribute: endAttribute)
                    }
                case .timeLineSwatchScale(let timeLineSwatchDataStart):
                    jiggleDocument.snapShotLoopAttributeOne(attributeType: .timeLineSwatchScale,
                                                            targetJiggleIndex: jiggleDocument.snapShotLoopAttributeOneTargetIndex,
                                                            selectedTimeLineSwatch: timeLineSwatchDataStart.selectedSwatch)
                    if let endAttribute = jiggleDocument.snapShotLoopAttributeOne {
                        historyRecordLoopAttributeOne(jiggleIndex: jiggleDocument.snapShotLoopAttributeOneTargetIndex,
                                                      startAttribute: startAttribute,
                                                      endAttribute: endAttribute)
                    }
                case .timeLineSwatchRotation(let timeLineSwatchDataStart):
                    jiggleDocument.snapShotLoopAttributeOne(attributeType: .timeLineSwatchRotation,
                                                            targetJiggleIndex: jiggleDocument.snapShotLoopAttributeOneTargetIndex,
                                                            selectedTimeLineSwatch: timeLineSwatchDataStart.selectedSwatch)
                    if let endAttribute = jiggleDocument.snapShotLoopAttributeOne {
                        historyRecordLoopAttributeOne(jiggleIndex: jiggleDocument.snapShotLoopAttributeOneTargetIndex,
                                                      startAttribute: startAttribute,
                                                      endAttribute: endAttribute)
                    }
                }
            }
        }
    }
    
    @MainActor func snapshotTimeLineHistoryForTimeLineViewDrag(jiggle: Jiggle) {
        if isAnimationLoopsAppliedToAll {
            snapshotTimeLineHistoryForOneSwatchAll(jiggle: jiggle)
        } else {
            snapshotTimeLineHistoryForOneSwatchSelected(jiggle: jiggle)
        }
    }
    
    @MainActor func recordTimeLineHistoryForTimeLineViewDrag() {
        recordTimeLineHistoryForOneSwatch()
    }
    
    func isSliderActiveBesides(thisSlider: ToolInterfaceElement) -> Bool {
        if isAnySliderActive {
            if activeSlider == .buttonMenu {
                return false
            }
            if activeSlider == thisSlider {
                return false
            }
            return true
        } else {
            return false
        }
    }
    
    var isAnySliderActive = false
    var isAnySliderActiveStaleTime = Float(0.0)
    var activeSlider = ToolInterfaceElement.buttonMenu
    
    @MainActor func ANY_sliderActiveNotify(whichSlider: ToolInterfaceElement) {
        print("*** SLIDER ACTIVE!!!")
        isAnySliderActive = true
        activeSlider = whichSlider
        if let toolInterfaceViewModel = toolInterfaceViewModel {
            toolInterfaceViewModel.handleSliderActiveDidChange()
        }
    }
    
    @MainActor func ANY_sliderInactiveNotify() {
        print("*** SLIDER INACTIVE!!!")
        isAnySliderActive = false
        activeSlider = ToolInterfaceElement.buttonMenu
        if let toolInterfaceViewModel = toolInterfaceViewModel {
            toolInterfaceViewModel.handleSliderActiveDidChange()
        }
    }
    
    
    
    @MainActor func selectTimeLineSwatch(swatch: Swatch) {
        selectedTimeLineSwatch = swatch
        jiggleDocument.selectedTimeLineSwatchUpdatePublisher.send(())
        if let toolInterfaceViewModel = toolInterfaceViewModel {
            toolInterfaceViewModel.handleTimelinePointCountDidChange()
        }
    }
    
    @MainActor func setContinuousDisableGrab(isEnabled: Bool) {
        jiggleDocument.isContinuousDisableGrabEnabled = isEnabled
        if let toolInterfaceViewModel = toolInterfaceViewModel {
            toolInterfaceViewModel.handleContinuousDisableGrabDidChange()
        }
    }
    
    var sliderStartedJiggleSpeedValueNodes = [HistorySingleJiggleValueNode]()
    var sliderStartedJigglePowerValueNodes = [HistorySingleJiggleValueNode]()
    var sliderStartedJiggleDampenValueNodes = [HistorySingleJiggleValueNode]()
    
    
    
    
    
    
    
    private(set) var isRecordingEnabled = true
    @MainActor func startVideoRecording() {
        if isRecordingEnabled == false {
            isRecordingEnabled = true
            toolInterfaceViewModel.handleRecordingEnabledDidChange()
        }
    }
    
    @MainActor func stopVideoRecording() {
        if isRecordingEnabled == false {
            isRecordingEnabled = true
            //toolInterfaceViewModel.handlRecordingEnabledDidChange()
        }
    }
    
    @MainActor func zoomReset() {
        if isResetZoomActive == false {
            self.isResetZoomActive = true
            cancelAllTouchesAndGestures(touches: [],
                                        points: [])
            resetZoomActiveUpdatePublisher.send(())
            resetZoomAnimationTimeElapsed = 0.0
            
            resetZoomEndScale = jiggleScene.normalBoxScaleBase
            resetZoomEndX = jiggleScene.normalBoxTranslationBase.x
            resetZoomEndY = jiggleScene.normalBoxTranslationBase.y
            
            
            resetZoomStartScale = jiggleScene.normalBoxScale; resetZoomStartRotation = jiggleScene.normalBoxRotation
            resetZoomStartX = jiggleScene.normalBoxTranslation.x; resetZoomStartY = jiggleScene.normalBoxTranslation.y
        }
    }
    
    
    @MainActor func zoomJiggle() {
        
        if let selectedJiggle = getSelectedJiggle() {
            if isResetZoomActive == false {
                
                //selectedJiggle.refreshOutline()
                if selectedJiggle.outlineJiggleWeightPointCount > 0 {
                    
                    let _point0 = selectedJiggle.outlineJiggleWeightPoints[0].point
                    let point0 = jiggleScene.convertFromSceneToWorld(point: _point0,
                                                                     translation: .zero,
                                                                     scale: 1.0,
                                                                     rotation: -jiggleScene.normalBoxRotation,
                                                                     frameX: 0.0,
                                                                     frameY: 0.0)
                    
                    var centerMinX = _point0.x
                    var centerMaxX = _point0.x
                    var centerMinY = _point0.y
                    var centerMaxY = _point0.y
                    
                    var scaleMinX = point0.x
                    var scaleMaxX = point0.x
                    var scaleMinY = point0.y
                    var scaleMaxY = point0.y
                    
                    for outlineJiggleWeightPointIndex in 0..<selectedJiggle.outlineJiggleWeightPointCount {
                        let x = selectedJiggle.outlineJiggleWeightPoints[outlineJiggleWeightPointIndex].x
                        let y = selectedJiggle.outlineJiggleWeightPoints[outlineJiggleWeightPointIndex].y
                        
                        centerMinX = min(centerMinX, x)
                        centerMaxX = max(centerMaxX, x)
                        centerMinY = min(centerMinY, y)
                        centerMaxY = max(centerMaxY, y)
                        
                        let point = Point(x: x, y: y)
                        let converted = jiggleScene.convertFromSceneToWorld(point: point,
                                                                            translation: .zero,
                                                                            scale: 1.0,
                                                                            rotation: -jiggleScene.normalBoxRotation,
                                                                            frameX: 0.0,
                                                                            frameY: 0.0)
                        scaleMinX = min(scaleMinX, converted.x)
                        scaleMaxX = max(scaleMaxX, converted.x)
                        scaleMinY = min(scaleMinY, converted.y)
                        scaleMaxY = max(scaleMaxY, converted.y)
                    }
                    
                    var rangeScaleX = abs(scaleMaxX - scaleMinX)
                    if rangeScaleX < 32.0 { rangeScaleX = 32.0 }
                    
                    var rangeScaleY = abs(scaleMaxY - scaleMinY)
                    if rangeScaleY < 32.0 { rangeScaleY = 32.0 }
                    
                    let appWidth: Float
                    let appHeight: Float
                    switch jiggleDocument.orientation {
                    case .landscape:
                        appWidth = Device.widthLandscape
                        appHeight = Device.heightLandscape
                    case .portrait:
                        appWidth = Device.widthPortrait
                        appHeight = Device.heightPortrait
                    }
                    
                    if appWidth > 16.0 && appHeight > 16.0 {
                        
                        self.isResetZoomActive = true
                        cancelAllTouchesAndGestures(touches: [], points: [])
                        
                        resetZoomActiveUpdatePublisher.send(())
                        resetZoomAnimationTimeElapsed = 0.0
                        
                        resetZoomStartScale = jiggleScene.normalBoxScale; resetZoomStartRotation = jiggleScene.normalBoxRotation
                        resetZoomStartX = jiggleScene.normalBoxTranslation.x; resetZoomStartY = jiggleScene.normalBoxTranslation.y
                        
                        let scaleFactorX = rangeScaleX / appWidth
                        let scaleFactorY = rangeScaleY / appHeight
                        let appScale = max(scaleFactorX, scaleFactorY)
                        resetZoomEndScale = (1.0 / appScale)
                        
                        // With this new scale (resetZoomEndScale), we now want
                        // the point (sceneOldCenterX, sceneOldCenterY) centered
                        // at the center of the screen...
                        
                        let screenCenterX = appWidth * 0.5
                        let screenCenterY = appHeight * 0.5
                        let convertedScreenCenter = jiggleScene.convertFromWorldToScene(point: Point(x: screenCenterX,
                                                                                                     y: screenCenterY),
                                                                                        translation: .zero,
                                                                                        scale: resetZoomEndScale,
                                                                                        rotation: 0.0,
                                                                                        frameX: 0.0, frameY: 0.0)
                        
                        let sceneJiggleCenterX = centerMinX + (centerMaxX - centerMinX) * 0.5
                        let sceneJiggleCenterY = centerMinY + (centerMaxY - centerMinY) * 0.5
                        
                        resetZoomEndX = (convertedScreenCenter.x - sceneJiggleCenterX) * resetZoomEndScale
                        resetZoomEndY = (convertedScreenCenter.y - sceneJiggleCenterY) * resetZoomEndScale
                    }
                }
            }
        }
    }
    
    @MainActor func selectNextJiggle() {
        jiggleDocument.selectNextJiggle(displayMode: displayMode,
                                        isGraphEnabled: isGraphEnabled,
                                        isPrecise: isRenderingPrecise)
    }
    
    @MainActor func selectPreviousJiggle() {
        jiggleDocument.selectPreviousJiggle(displayMode: displayMode,
                                            isGraphEnabled: isGraphEnabled,
                                            isPrecise: isRenderingPrecise)
    }
    
    @MainActor func selectNextGuide() {
        jiggleDocument.selectNextGuide(displayMode: displayMode,
                                       isGraphEnabled: isGraphEnabled,
                                       isPrecise: isRenderingPrecise)
    }
    
    @MainActor func selectPreviousGuide() {
        jiggleDocument.selectPreviousGuide(displayMode: displayMode,
                                           isGraphEnabled: isGraphEnabled,
                                           isPrecise: isRenderingPrecise)
    }
    
    @MainActor func selectNextJigglePoint() {
        jiggleDocument.selectNextJigglePoint(displayMode: displayMode,
                                             isGraphEnabled: isGraphEnabled,
                                             isPrecise: isRenderingPrecise)
        animatePreciseBoxFromSomethingChanged()
    }
    
    @MainActor func selectPreviousJigglePoint() {
        jiggleDocument.selectPreviousJigglePoint(displayMode: displayMode,
                                                 isGraphEnabled: isGraphEnabled,
                                                 isPrecise: isRenderingPrecise)
        animatePreciseBoxFromSomethingChanged()
    }
    
    @MainActor func selectNextGuidePoint() {
        jiggleDocument.selectNextGuidePoint(displayMode: displayMode,
                                            isGraphEnabled: isGraphEnabled,
                                            isPrecise: isRenderingPrecise)
        animatePreciseBoxFromSomethingChanged()
    }
    
    @MainActor func selectPreviousGuidePoint() {
        jiggleDocument.selectPreviousGuidePoint(displayMode: displayMode,
                                                isGraphEnabled: isGraphEnabled,
                                                isPrecise: isRenderingPrecise)
        animatePreciseBoxFromSomethingChanged()
    }
    
    //var displayMode = DisplayMode.regular
    var displayMode: DisplayMode {
        if isGraphEnabled {
            return .swivel
        } else {
            return .regular
        }
    }
    
    var isGraphMode: Bool {
        if jiggleDocument.isGuidesMode {
            if isGraphEnabled {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    var isVideoRecordEnabled = false
    var isVideoExportEnabled = false
    
    var isPadMenuExpanded = true
    
    var isPhoneTopMenuExpanded = true
    var isPhoneBottomMenuExpanded = true
    
    var isRenderingDisplayRegular: Bool = true
    var isRenderingDisplaySwivel: Bool = false
    
    var isRenderingPrecise: Bool = false
    
    
    var isAnimationGrabAppliedToAll = true
    var isAnimationLoopsAppliedToAll = false
    var isAnimationContinuousAppliedToAll = false
    //var isAnimationTwistAppliedToAll = false
    //var isAnimationWobbleAppliedToAll = false
    
    
    @MainActor func isAnyJiggleFrozen() -> Bool {
        jiggleDocument.isAnyJiggleFrozen()
    }
    
    @MainActor func unfreezeAllJiggles() {
        jiggleDocument.unfreezeAllJiggles(displayMode: displayMode,
                                          isGraphEnabled: isGraphEnabled,
                                          isPrecise: isRenderingPrecise)
        toolInterfaceViewModel.handleFrozenJigglesDidChange()
    }
    
    @MainActor func freezeSelectedJiggle() {
        jiggleDocument.freezeSelectedJiggle(displayMode: displayMode,
                                            isGraphEnabled: isGraphEnabled,
                                            isPrecise: isRenderingPrecise)
        toolInterfaceViewModel.handleFrozenJigglesDidChange()
    }
    
    @MainActor func unfreezeAllGuides() {
        jiggleDocument.unfreezeAllGuides(displayMode: displayMode,
                                         isGraphEnabled: isGraphEnabled,
                                         isPrecise: isRenderingPrecise)
        toolInterfaceViewModel.handleFrozenGuidesDidChange()
    }
    
    @MainActor func freezeSelectedGuide() {
        jiggleDocument.freezeSelectedGuide(displayMode: displayMode,
                                           isGraphEnabled: isGraphEnabled,
                                           isPrecise: isRenderingPrecise)
        toolInterfaceViewModel.handleFrozenGuidesDidChange()
    }
    
    @MainActor func setJiggleOpacity(_ jiggleOpacity: Float) {
        ApplicationController.userJiggleOpacity = jiggleOpacity
        jiggleDocument.setJiggleOpacity(jiggleOpacity)
    }
    
    //
    // Architectural Flaw: The view model should not reference the "view layer", instead it
    // should broadcast events, which the view layer receives. We are doing this very frequently
    // with the Combine (tm) publishers on the "model" layer...
    //
    // There are just too many button actions to make a separate publisher for each one,
    // so we are keeping the bad architecture until v1 is released.
    //
    weak var jiggleViewController: JiggleViewController?
    
    
    
    static let tanFactorJiggleControlPoint = Float(Device.isPad ? 0.41 : 0.3)
    static let tanFactorGuideControlPoint = Float(Device.isPad ? 0.41 : 0.3)
    
    static let tanFactorWeightCurve = Float(0.325)
    static let tanFactorTimeLine = Float(0.325)
    
    static let tanFactorWeightCurveAutoMidde7 = Float(0.26)
    static let tanFactorWeightCurveAutoMidde6 = Float(0.27)
    static let tanFactorWeightCurveAutoMidde5 = Float(0.28)
    static let tanFactorWeightCurveAutoMidde4 = Float(0.29)
    static let tanFactorWeightCurveAutoMidde3 = Float(0.30)
    
    static func tanFactorWeightCurveAuto(count: Int) -> Float {
        if count >= 7 {
            return JiggleViewModel.tanFactorWeightCurveAutoMidde7
        } else if count == 6 {
            return JiggleViewModel.tanFactorWeightCurveAutoMidde6
        } else if count == 5 {
            return JiggleViewModel.tanFactorWeightCurveAutoMidde5
        } else if count == 4 {
            return JiggleViewModel.tanFactorWeightCurveAutoMidde4
        } else {
            return tanFactorWeightCurveAutoMidde3
        }
    }
    
    //static let tanFactorWeightCurveAutoStart = Float(0.6)
    //static let tanFactorWeightCurveAutoEnd = Float(0.6)
    
    @MainActor func applyMeshCommandAllJiggles(meshCommand: JiggleMeshCommand,
                                               guideCommand: GuideCommand) {
        jiggleDocument.applyMeshCommandAllJiggles(meshCommand: meshCommand,
                                                  guideCommand: guideCommand,
                                                  isPrecise: isRenderingPrecise)
    }
    
    @MainActor func applyMeshCommandOneJiggle(meshCommand: JiggleMeshCommand,
                                              guideCommand: GuideCommand,
                                              jiggle: Jiggle) {
        jiggleDocument.applyMeshCommandOneJiggle(meshCommand: meshCommand,
                                                 guideCommand: guideCommand,
                                                 jiggle: jiggle,
                                                 isPrecise: isRenderingPrecise)
    }
    
    @MainActor func lockShowingState() {
        jiggleDocument.lockShowingState()
    }
    
    @MainActor func unlockShowingState() {
        jiggleDocument.unlockShowingState()
    }
    
    @MainActor lazy var swivelCoordinator: SwivelCoordinator = {
        let camera = jiggleScene.camera
        let result = SwivelCoordinator(camera: camera)
        return result
    }()
    
    typealias Point = Math.Point
    typealias Vector = Math.Vector
    
    weak var gestureView: GestureView?
    
    @MainActor var isBlocked: Bool {
        toolInterfaceViewModel.isBlocked
    }
    
    @MainActor var isBlockedAnyTransition: Bool {
        toolInterfaceViewModel.isBlockedAnyTransition
    }
    
    @MainActor var isBlockedExceptForHistory: Bool {
        toolInterfaceViewModel.isBlockedExceptForHistory
    }
    
    
    
    var isStereoscopicEnabled = false
    
    
    var isDisplayTransitionActive: Bool {
        jiggleScene.isDisplayTransitionActiveRegular || jiggleScene.isDisplayTransitionActiveSwivel
    }
    
    
    var subscriptions = [AnyCancellable]()
    func dispose() {
        for subscription in subscriptions {
            subscription.cancel()
        }
        subscriptions.removeAll()
    }
    
    
    static let resetZoomAnimationTime = Float(0.6)
    private(set) var isResetZoomActive = false
    private var resetZoomAnimationTimeElapsed = Float(0.0)
    var resetZoomActiveUpdatePublisher = PassthroughSubject<Void, Never>()
    private var resetZoomStartScale = Float(0.0)
    private var resetZoomStartRotation = Float(0.0)
    private var resetZoomStartX = Float(0.0)
    private var resetZoomStartY = Float(0.0)
    private var resetZoomEndScale = Float(0.0)
    private let resetZoomEndRotation = Float(0.0)
    private var resetZoomEndX = Float(0.0)
    private var resetZoomEndY = Float(0.0)
    
    static let resetPreciseMagnifiedBoxAnimationTime = Float(0.28)
    private(set) var isResetPreciseMagnifiedBoxActive = false
    private var resetPreciseMagnifiedBoxAnimationTimeElapsed = Float(0.0)
    private var resetPreciseMagnifiedBoxStartScale = Float(0.0)
    private var resetPreciseMagnifiedBoxStartRotation = Float(0.0)
    private var resetPreciseMagnifiedBoxStartX = Float(0.0)
    private var resetPreciseMagnifiedBoxStartY = Float(0.0)
    private var resetPreciseMagnifiedBoxEndScale = Float(0.0)
    private var resetPreciseMagnifiedBoxEndRotation = Float(0.0)
    private var resetPreciseMagnifiedBoxEndX = Float(0.0)
    private var resetPreciseMagnifiedBoxEndY = Float(0.0)
    
    static let resetPreciseDistantBoxAnimationTime = Float(0.28)
    private(set) var isResetPreciseDistantBoxActive = false
    private var resetPreciseDistantBoxAnimationTimeElapsed = Float(0.0)
    private var resetPreciseDistantBoxStartScale = Float(0.0)
    private var resetPreciseDistantBoxStartRotation = Float(0.0)
    private var resetPreciseDistantBoxStartX = Float(0.0)
    private var resetPreciseDistantBoxStartY = Float(0.0)
    private var resetPreciseDistantBoxEndScale = Float(0.0)
    private var resetPreciseDistantBoxEndRotation = Float(0.0)
    private var resetPreciseDistantBoxEndX = Float(0.0)
    private var resetPreciseDistantBoxEndY = Float(0.0)
    
    
    
    var documentMode: DocumentMode {
        jiggleDocument.documentMode
    }
    
    var weightMode: WeightMode {
        jiggleDocument.weightMode
    }
    
    var orientation: Orientation {
        jiggleDocument.orientation
    }
    
    let sceneWidth: Float
    let sceneHeight: Float
    let jiggleScene: JiggleScene
    let jiggleEngine: JiggleEngine
    let jiggleDocument: JiggleDocument
    let rootViewModel: RootViewModel
    
    var toolInterfaceViewModel: ToolInterfaceViewModel!
    
    @MainActor init(jiggleScene: JiggleScene,
                    jiggleDocument: JiggleDocument,
                    rootViewModel: RootViewModel) {
        self.jiggleScene = jiggleScene
        self.jiggleEngine = jiggleScene.jiggleEngine
        self.jiggleDocument = jiggleDocument
        self.rootViewModel = rootViewModel
        
        switch jiggleDocument.orientation {
        case .landscape:
            sceneWidth = Device.widthLandscape
            sceneHeight = Device.heightLandscape
        case .portrait:
            sceneWidth = Device.widthPortrait
            sceneHeight = Device.heightPortrait
        }
        
        jiggleDocument.jiggleScene = jiggleScene
        
        self.toolInterfaceViewModel = ToolInterfaceViewModel(orientation: orientation, jiggleViewModel: self)
        
        ApplicationController.shared.jiggleViewModel = self
    }
    
    var autoSaveTimer = Float(0.0)
    @MainActor func update(deltaTime: Float) {
        
        var isStereoscopicEnabled = false
        if let jiggleViewController = jiggleViewController {
            isStereoscopicEnabled = jiggleViewController.isStereoscopicEnabled
        }
                
        let isTransitionActive = (jiggleScene.isDisplayTransitionActiveRegular ||
                                  jiggleScene.isDisplayTransitionActiveSwivel ||
                                  jiggleScene.isPreciseTransitionActiveExit ||
                                  jiggleScene.isPreciseTransitionActiveEnter ||
                                  isResetPreciseDistantBoxActive ||
                                  isResetPreciseMagnifiedBoxActive)
        
        var isJoyPadTargetLockedJigglePoint = false
        var isJoyPadTargetLockedGuidePoint = false
        
        
        if jiggleDocument.isJoyPadTargetLocked {
            if jiggleDocument.joyPadGuideControlPoint !== nil &&
                jiggleDocument.joyPadGuide !== nil &&
                jiggleDocument.joyPadJiggle !== nil {
                isJoyPadTargetLockedGuidePoint = true
            }
            if jiggleDocument.joyPadJiggleControlPoint !== nil &&
                jiggleDocument.joyPadJiggle !== nil {
                isJoyPadTargetLockedJigglePoint = true
            }
        }
        
        jiggleDocument.update(jiggleViewModel: self,
                              deltaTime: deltaTime,
                              displayMode: displayMode,
                              weightMode: weightMode,
                              isStereoscopicEnabled: isStereoscopicEnabled,
                              isGraphEnabled: isGraphEnabled,
                              isTransitionActive: isTransitionActive,
                              isPrecisePointsEnabled: isPrecisePointsEnabled,
                              isJoyPadTargetLockedJigglePoint: isJoyPadTargetLockedJigglePoint,
                              isJoyPadTargetLockedGuidePoint: isJoyPadTargetLockedGuidePoint,
                              isPrecise: isRenderingPrecise)
        
        swivelCoordinator.update(deltaTime: deltaTime,
                                 jiggle: getSelectedJiggle())
        
        autoSaveTimer += deltaTime
        if autoSaveTimer >= 5.0 {
            autoSaveTimer -= 5.0
            _ = jiggleDocument.writeSceneFileToRecent()
        }
        
        if isResetZoomActive {
            resetZoomAnimationTimeElapsed += deltaTime
            if resetZoomAnimationTimeElapsed >= Self.resetZoomAnimationTime {
                jiggleScene.normalBoxScale = resetZoomEndScale
                jiggleScene.normalBoxRotation = resetZoomEndRotation
                jiggleScene.normalBoxTranslation.x = resetZoomEndX
                jiggleScene.normalBoxTranslation.y = resetZoomEndY
                isResetZoomActive = false
                resetZoomActiveUpdatePublisher.send(())
            } else {
                var percent = resetZoomAnimationTimeElapsed / Self.resetZoomAnimationTime
                percent = sinf(Float(percent * (Math.pi_2)))
                if percent < 0.0 { percent = 0.0 }
                if percent > 1.0 { percent = 1.0 }
                let rotationDistance = Math.distanceBetweenAngles(resetZoomStartRotation, resetZoomEndRotation)
                jiggleScene.normalBoxRotation = resetZoomStartRotation + (rotationDistance * percent)
                jiggleScene.normalBoxScale = resetZoomStartScale + (resetZoomEndScale - resetZoomStartScale) * percent
                jiggleScene.normalBoxTranslation.x = resetZoomStartX + (resetZoomEndX - resetZoomStartX) * percent
                jiggleScene.normalBoxTranslation.y = resetZoomStartY + (resetZoomEndY - resetZoomStartY) * percent
            }
        }
        
        if jiggleScene.isPreciseTransitionActiveEnter == false &&
            jiggleScene.isPreciseTransitionActiveExit == false {
            if isResetPreciseMagnifiedBoxActive {
                resetPreciseMagnifiedBoxAnimationTimeElapsed += deltaTime
                if resetPreciseMagnifiedBoxAnimationTimeElapsed >= Self.resetPreciseMagnifiedBoxAnimationTime {
                    jiggleScene.preciseMagnifiedScale = resetPreciseMagnifiedBoxEndScale
                    jiggleScene.preciseMagnifiedRotation = resetPreciseMagnifiedBoxEndRotation
                    jiggleScene.preciseMagnifiedTranslation.x = resetPreciseMagnifiedBoxEndX
                    jiggleScene.preciseMagnifiedTranslation.y = resetPreciseMagnifiedBoxEndY
                    isResetPreciseMagnifiedBoxActive = false
                } else {
                    var percent = resetPreciseMagnifiedBoxAnimationTimeElapsed / Self.resetPreciseMagnifiedBoxAnimationTime
                    percent = sinf(Float(percent * (Math.pi_2)))
                    if percent < 0.0 { percent = 0.0 }
                    if percent > 1.0 { percent = 1.0 }
                    let rotationDistance = Math.distanceBetweenAngles(resetPreciseMagnifiedBoxStartRotation, resetPreciseMagnifiedBoxEndRotation)
                    jiggleScene.preciseMagnifiedRotation = resetPreciseMagnifiedBoxStartRotation + (rotationDistance * percent)
                    jiggleScene.preciseMagnifiedScale = resetPreciseMagnifiedBoxStartScale + (resetPreciseMagnifiedBoxEndScale - resetPreciseMagnifiedBoxStartScale) * percent
                    jiggleScene.preciseMagnifiedTranslation.x = resetPreciseMagnifiedBoxStartX + (resetPreciseMagnifiedBoxEndX - resetPreciseMagnifiedBoxStartX) * percent
                    jiggleScene.preciseMagnifiedTranslation.y = resetPreciseMagnifiedBoxStartY + (resetPreciseMagnifiedBoxEndY - resetPreciseMagnifiedBoxStartY) * percent
                }
                
                let scaleMax = JiggleViewModel.preciseScaleAmountMagnifiedMax * jiggleScene.normalBoxScaleBase// * JiggleDocument.universeScale
                let scaleMin = JiggleViewModel.preciseScaleAmountMagnifiedMin * jiggleScene.normalBoxScaleBase// * JiggleDocument.universeScale
                let scalePercentNumer = (jiggleScene.preciseMagnifiedScale - scaleMin)
                let scalePercentDenom = (scaleMax - scaleMin)
                var scalePercent = Float(1.0)
                if scalePercentDenom > Math.epsilon {
                    scalePercent = scalePercentNumer / scalePercentDenom
                }
                if scalePercent < 0.0 { scalePercent = 0.0 }
                if scalePercent > 1.0 { scalePercent = 1.0 }
                ApplicationController.preciseScaleAmount = JiggleViewModel.preciseScaleAmountUserMin + (JiggleViewModel.preciseScaleAmountUserMax - JiggleViewModel.preciseScaleAmountUserMin) * scalePercent
                toolInterfaceViewModel.handlePreciseScaleDidChange()
            }
            
            if isResetPreciseDistantBoxActive {
                resetPreciseDistantBoxAnimationTimeElapsed += deltaTime
                if resetPreciseDistantBoxAnimationTimeElapsed >= Self.resetPreciseDistantBoxAnimationTime {
                    jiggleScene.preciseDistantScale = resetPreciseDistantBoxEndScale
                    jiggleScene.preciseDistantRotation = resetPreciseDistantBoxEndRotation
                    jiggleScene.preciseDistantTranslation.x = resetPreciseDistantBoxEndX
                    jiggleScene.preciseDistantTranslation.y = resetPreciseDistantBoxEndY
                    isResetPreciseDistantBoxActive = false
                } else {
                    var percent = resetPreciseDistantBoxAnimationTimeElapsed / Self.resetPreciseDistantBoxAnimationTime
                    percent = sinf(Float(percent * (Math.pi_2)))
                    if percent < 0.0 { percent = 0.0 }
                    if percent > 1.0 { percent = 1.0 }
                    let rotationDistance = Math.distanceBetweenAngles(resetPreciseDistantBoxStartRotation, resetPreciseDistantBoxEndRotation)
                    jiggleScene.preciseDistantRotation = resetPreciseDistantBoxStartRotation + (rotationDistance * percent)
                    jiggleScene.preciseDistantScale = resetPreciseDistantBoxStartScale + (resetPreciseDistantBoxEndScale - resetPreciseDistantBoxStartScale) * percent
                    jiggleScene.preciseDistantTranslation.x = resetPreciseDistantBoxStartX + (resetPreciseDistantBoxEndX - resetPreciseDistantBoxStartX) * percent
                    jiggleScene.preciseDistantTranslation.y = resetPreciseDistantBoxStartY + (resetPreciseDistantBoxEndY - resetPreciseDistantBoxStartY) * percent
                }
            }
        }
    }
    
    @MainActor func setAnimationGrabAppliedToAll(_ isAnimationGrabAppliedToAll: Bool) {
        self.isAnimationGrabAppliedToAll = isAnimationGrabAppliedToAll
        toolInterfaceViewModel.handleAnimationGrabAppliedToAllDidChange()
    }
    
    @MainActor func setAnimationLoopsAppliedToAll(_ isAnimationLoopsAppliedToAll: Bool) {
        print("isAnimationLoopsAppliedToAll => \(isAnimationLoopsAppliedToAll)")
        self.isAnimationLoopsAppliedToAll = isAnimationLoopsAppliedToAll
        toolInterfaceViewModel.handleAnimationLoopsAppliedToAllDidChange()
    }
    
    @MainActor func setUnifyTangentsEnabled(_ isUnifyTangentsEnabled: Bool) {
        print("isUnifyTangentsEnabled => \(isUnifyTangentsEnabled)")
        jiggleDocument.isUnifyTangentsEnabled = isUnifyTangentsEnabled
        toolInterfaceViewModel.handleUnifyTangentsEnabledDidChange()
    }
    
    @MainActor func setGlowingSelectionEnabled(_ isGlowingSelectionEnabled: Bool) {
        ApplicationController.isGlowingSelectionEnabled = isGlowingSelectionEnabled
        toolInterfaceViewModel.handleGlowingSelectionEnabledDidChange()
        ApplicationController.shared.configSave()
    }
    
    @MainActor func setShowInsetMarkersGuides(_ isShowInsetMarkersGuides: Bool) {
        ApplicationController.isGuideInsetMarkersEnabled = isShowInsetMarkersGuides
        toolInterfaceViewModel.handleShowInsetMarkersGuidesDidChange()
        ApplicationController.shared.configSave()
    }
    
    @MainActor func toggleManualJigglePointDirection() {
        if let selectedJiggle = jiggleDocument.getSelectedJiggle() {
            if let selectedJiggleControlPoint = selectedJiggle.getSelectedJiggleControlPoint() {
                let jiggleIndex = jiggleDocument.selectedJiggleIndex
                let controlPointIndex = selectedJiggle.selectedJiggleControlPointIndex
                
                let startManual = selectedJiggleControlPoint.isManualTanHandleEnabled
                let startUnified = selectedJiggleControlPoint.isUnifiedTan
                let startDirectionIn = selectedJiggleControlPoint.tanDirectionIn
                let startDirectionOut = selectedJiggleControlPoint.tanDirectionOut
                let startMagnitudeIn = selectedJiggleControlPoint.tanMagnitudeIn
                let startMagnitudeOut = selectedJiggleControlPoint.tanMagnitudeOut
                
                selectedJiggleControlPoint.isManualTanHandleEnabled = !selectedJiggleControlPoint.isManualTanHandleEnabled
                if selectedJiggleControlPoint.isManualTanHandleEnabled == true &&
                    selectedJiggleControlPoint.isTanHandleEverModifiedByUserDrag == true {
                    selectedJiggleControlPoint.isUnifiedTan = selectedJiggleControlPoint.storedUserDragTanUnified
                    selectedJiggleControlPoint.tanDirectionIn = selectedJiggleControlPoint.storedUserDragTanDirectionIn
                    selectedJiggleControlPoint.tanDirectionOut = selectedJiggleControlPoint.storedUserDragTanDirectionOut
                    selectedJiggleControlPoint.tanMagnitudeIn = selectedJiggleControlPoint.storedUserDragTanMagnitudeIn
                    selectedJiggleControlPoint.tanMagnitudeOut = selectedJiggleControlPoint.storedUserDragTanMagnitudeOut
                }
                
                jiggleDocument.refreshJigglePoint(jiggle: selectedJiggle,
                                                  displayMode: displayMode,
                                                  isGraphEnabled: isGraphEnabled,
                                                  isPrecise: isRenderingPrecise)
                
                let endManual = selectedJiggleControlPoint.isManualTanHandleEnabled
                let endUnified = selectedJiggleControlPoint.isUnifiedTan
                let endDirectionIn = selectedJiggleControlPoint.tanDirectionIn
                let endDirectionOut = selectedJiggleControlPoint.tanDirectionOut
                let endMagnitudeIn = selectedJiggleControlPoint.tanMagnitudeIn
                let endMagnitudeOut = selectedJiggleControlPoint.tanMagnitudeOut
                
                toolInterfaceViewModel.handleManualJigglePointDirectionDidChange()
                
                historyRecordEditJiggleControlPointTanHandle(jiggleIndex: jiggleIndex,
                                                             controlPointIndex: controlPointIndex,
                                                             tanType: .in,
                                                             startManual: startManual,
                                                             startUnified: startUnified,
                                                             startDirectionIn: startDirectionIn,
                                                             startDirectionOut: startDirectionOut,
                                                             startMagnitudeIn: startMagnitudeIn,
                                                             startMagnitudeOut: startMagnitudeOut,
                                                             endManual: endManual,
                                                             endUnified: endUnified,
                                                             endDirectionIn: endDirectionIn,
                                                             endDirectionOut: endDirectionOut,
                                                             endMagnitudeIn: endMagnitudeIn,
                                                             endMagnitudeOut: endMagnitudeOut)
            }
        }
    }
    
    @MainActor func toggleManualGuidePointDirection() {
        if let selectedJiggle = jiggleDocument.getSelectedJiggle() {
            if let selectedGuide = selectedJiggle.getSelectedGuide() {
                if let selectedGuideIndex = selectedJiggle.getGuideIndex(selectedGuide) {
                    if let selectedGuideControlPoint = selectedGuide.getSelectedGuideControlPoint() {
                        
                        let jiggleIndex = jiggleDocument.selectedJiggleIndex
                        let weightCurveIndex = (selectedGuideIndex + 1)
                        let guideControlPointIndex = selectedGuide.selectedGuideControlPointIndex
                        
                        let startManual = selectedGuideControlPoint.isManualTanHandleEnabled
                        let startUnified = selectedGuideControlPoint.isUnifiedTan
                        let startDirectionIn = selectedGuideControlPoint.tanDirectionIn
                        let startDirectionOut = selectedGuideControlPoint.tanDirectionOut
                        let startMagnitudeIn = selectedGuideControlPoint.tanMagnitudeIn
                        let startMagnitudeOut = selectedGuideControlPoint.tanMagnitudeOut
                        
                        selectedGuideControlPoint.isManualTanHandleEnabled = !selectedGuideControlPoint.isManualTanHandleEnabled
                        if selectedGuideControlPoint.isManualTanHandleEnabled == true &&
                            selectedGuideControlPoint.isTanHandleEverModifiedByUserDrag == true {
                            selectedGuideControlPoint.isUnifiedTan = selectedGuideControlPoint.storedUserDragTanUnified
                            selectedGuideControlPoint.tanDirectionIn = selectedGuideControlPoint.storedUserDragTanDirectionIn
                            selectedGuideControlPoint.tanDirectionOut = selectedGuideControlPoint.storedUserDragTanDirectionOut
                            selectedGuideControlPoint.tanMagnitudeIn = selectedGuideControlPoint.storedUserDragTanMagnitudeIn
                            selectedGuideControlPoint.tanMagnitudeOut = selectedGuideControlPoint.storedUserDragTanMagnitudeOut
                        }
                        
                        jiggleDocument.refreshGuidePoint(jiggle: selectedJiggle,
                                                         guide: selectedGuide,
                                                         displayMode: displayMode,
                                                         isGraphEnabled: isGraphEnabled,
                                                         isPrecise: isRenderingPrecise)
                        
                        let endManual = selectedGuideControlPoint.isManualTanHandleEnabled
                        let endUnified = selectedGuideControlPoint.isUnifiedTan
                        let endDirectionIn = selectedGuideControlPoint.tanDirectionIn
                        let endDirectionOut = selectedGuideControlPoint.tanDirectionOut
                        let endMagnitudeIn = selectedGuideControlPoint.tanMagnitudeIn
                        let endMagnitudeOut = selectedGuideControlPoint.tanMagnitudeOut
                        
                        toolInterfaceViewModel.handleManualGuidePointDirectionDidChange()
                        
                        historyRecordEditGuideControlPointTanHandle(jiggleIndex: jiggleIndex,
                                                                    weightCurveIndex: weightCurveIndex,
                                                                    guideControlPointIndex: guideControlPointIndex,
                                                                    tanType: .in,
                                                                    startManual: startManual,
                                                                    startUnified: startUnified,
                                                                    startDirectionIn: startDirectionIn,
                                                                    startDirectionOut: startDirectionOut,
                                                                    startMagnitudeIn: startMagnitudeIn,
                                                                    startMagnitudeOut: startMagnitudeOut,
                                                                    endManual: endManual,
                                                                    endUnified: endUnified,
                                                                    endDirectionIn: endDirectionIn,
                                                                    endDirectionOut: endDirectionOut,
                                                                    endMagnitudeIn: endMagnitudeIn,
                                                                    endMagnitudeOut: endMagnitudeOut)
                    }
                }
            }
        }
    }
    
    @MainActor func setShowExtraInsetMarkers(_ isShowExtraInsetMarkersEnabled: Bool) {
        ApplicationController.isGuideInsetMarkersDenseEnabled = isShowExtraInsetMarkersEnabled
        toolInterfaceViewModel.handleShowExtraInsetMarkersEnabledDidChange()
        ApplicationController.shared.configSave()
    }
    
    @MainActor func setPreciseJoyPadEnabled(_ isPreciseJoyPadEnabled: Bool) {
        //self.isPreciseJoyPadEnabled = isPreciseJoyPadEnabled
        ApplicationController.isPreciseJoyPadEnabled = isPreciseJoyPadEnabled
        toolInterfaceViewModel.handlePreciseJoyPadEnabledDidChange()
        ApplicationController.shared.configSave()
    }
    
    
    @MainActor func setAnimationContinuousAppliedToAll(_ isAnimationContinuousAppliedToAll: Bool) {
        print("setAnimationContinuousAppliedToAll => \(isAnimationContinuousAppliedToAll)")
        self.isAnimationContinuousAppliedToAll = isAnimationContinuousAppliedToAll
        toolInterfaceViewModel.handleAnimationContinuousAppliedToAllDidChange()
    }
    
    //func setResetZoomActive() {
    //}
    
    @MainActor func getSelectedJiggle() -> Jiggle? {
        return jiggleDocument.getSelectedJiggle()
    }
    
    @MainActor func getSelectedGuide() -> Guide? {
        return jiggleDocument.getSelectedGuide()
    }
    
    var isAnyJigglePresent: Bool {
        if jiggleDocument.jiggleCount > 0 {
            return true
        }
        return false
    }
    
    @MainActor func cancelAllTouchesAndGestures(touches: [UITouch], points: [Math.Point]) {
        if let gestureView = gestureView {
            gestureView.cancelAllGestureRecognizers()
            gestureView.cancelAllTouches(touches: [],
                                         points: [])
        }
    }
    
    @discardableResult
    @MainActor func attemptJiggleAffineSelectWithTouch(points: [Point],
                                                       touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        if jiggleDocument.attemptJiggleAffineSelectWithTouch(points: points,
                                                             includingFrozen: false,
                                                             displayMode: displayMode,
                                                             isGraphEnabled: isGraphEnabled,
                                                             touchTargetTouchSource: touchTargetTouchSource,
                                                             isPrecise: isRenderingPrecise) {
            return true
        }
        return false
    }
    
    @discardableResult
    @MainActor func attemptGuideAffineSelectWithTouch(points: [Point],
                                                      touchTargetTouchSource: TouchTargetTouchSource) -> Bool {
        if jiggleDocument.attemptGuideAffineSelectWithTouch(points: points,
                                                            includingFrozen: false,
                                                            displayMode: displayMode,
                                                            isGraphEnabled: isGraphEnabled,
                                                            touchTargetTouchSource: touchTargetTouchSource,
                                                            isPrecise: isRenderingPrecise) {
            return true
        }
        return false
    }
    
    @MainActor func attemptGrabDrawJiggles(touch: UITouch,
                                           point: Point) {
        _ = jiggleDocument.attemptGrabDrawJiggles(touch: touch,
                                                  point: point)
    }
    
    @MainActor func attemptGrabDrawGuides(touch: UITouch,
                                          point: Point) {
        _ = jiggleDocument.attemptGrabDrawGuides(touch: touch,
                                                 point: point)
    }
    
    @MainActor func attemptUpdateDrawJiggles(touch: UITouch,
                                             point: Point,
                                             isFromRelease: Bool) {
        _ = jiggleDocument.attemptUpdateDrawJiggles(touch: touch,
                                                    point: point,
                                                    baseAdjustScale: jiggleScene.baseAdjustScale,
                                                    isFromRelease: isFromRelease)
    }
    
    @MainActor func attemptUpdateDrawGuides(touch: UITouch,
                                            point: Point,
                                            isFromRelease: Bool) {
        _ = jiggleDocument.attemptUpdateDrawGuides(touch: touch,
                                                   point: point,
                                                   isFromRelease: isFromRelease)
    }
    
    @MainActor func attemptTouchesBegan_ViewMode_Yes(touches: [UITouch],
                                                     points: [Point],
                                                     allTouchCount: Int,
                                                     touchTargetTouchSource: TouchTargetTouchSource) {
        jiggleDocument.attemptTouchesBegan_ViewMode(jiggleViewModel: self,
                                                    touches: touches,
                                                    points: points,
                                                    allTouchCount: allTouchCount,
                                                    displayMode: displayMode,
                                                    isGraphEnabled: isGraphEnabled,
                                                    touchTargetTouchSource: touchTargetTouchSource,
                                                    isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptTouchesBegan_ViewMode_No(touches: [UITouch],
                                                    points: [Point],
                                                    allTouchCount: Int) {
        jiggleDocument.attemptKillDragAll_ViewMode(jiggleViewModel: self)
    }
    
    @MainActor func attemptTouchesMoved_ViewMode_Yes(touches: [UITouch],
                                                     points: [Point],
                                                     allTouchCount: Int,
                                                     touchTargetTouchSource: TouchTargetTouchSource) {
        jiggleDocument.attemptTouchesMoved_ViewMode(jiggleViewModel: self,
                                                    touches: touches,
                                                    points: points,
                                                    allTouchCount: allTouchCount,
                                                    displayMode: displayMode,
                                                    isGraphEnabled: isGraphEnabled,
                                                    touchTargetTouchSource: touchTargetTouchSource,
                                                    isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptTouchesMoved_ViewMode_No(touches: [UITouch],
                                                    points: [Point],
                                                    allTouchCount: Int) {
        jiggleDocument.attemptKillDragAll_ViewMode(jiggleViewModel: self)
    }
    
    @MainActor func attemptTouchesEnded_ViewMode_Yes(touches: [UITouch],
                                                     points: [Point],
                                                     allTouchCount: Int,
                                                     killDragReleaseSource: KillDragReleaseSource) {
        jiggleDocument.attemptTouchesEnded_ViewMode(jiggleViewModel: self,
                                                    touches: touches,
                                                    points: points,
                                                    allTouchCount: allTouchCount,
                                                    displayMode: displayMode,
                                                    isGraphEnabled: isGraphEnabled)
        
    }
    
    @MainActor func attemptTouchesEnded_ViewMode_No(touches: [UITouch],
                                                    points: [Point],
                                                    allTouchCount: Int) {
        jiggleDocument.attemptKillDragAll_ViewMode(jiggleViewModel: self)
    }
    
    @MainActor func attemptGrabJiggleControlPoint(touches: [UITouch],
                                                  points: [Point],
                                                  touchTargetTouchSource: TouchTargetTouchSource) {
        
        
        let _selectedJiggle = jiggleDocument.getSelectedJiggle()
        let _selectedJiggleControlPoint = jiggleDocument.getSelectedJiggleControlPoint()
        
        //TODO: Test
        if jiggleDocument.isUnifyTangentsEnabled {
            if jiggleDocument.attemptSelectNeighborJiggleControlPoint_PreciseMagnified(touches: touches,
                                                                                       points: points,
                                                                                       selectedJiggle: _selectedJiggle,
                                                                                       selectedJiggleControlPoint: _selectedJiggleControlPoint,
                                                                                       displayMode: displayMode,
                                                                                       isGraphEnabled: isGraphEnabled) {
                
                print("This is a valid neighbor selection toch")
                
            }
            return
        }
        
        if isAnimatingTouchArea(touchTargetTouchSource: touchTargetTouchSource) {
            print("We're animating in \(touchTargetTouchSource), stopping grab")
            return
        }
        
        if !jiggleDocument.attemptGrabJiggleControlPoint(jiggleViewModel: self,
                                                         touches: touches,
                                                         points: points,
                                                         displayMode: displayMode,
                                                         isGraphEnabled: isGraphEnabled,
                                                         touchTargetTouchSource: touchTargetTouchSource,
                                                         isPrecise: isRenderingPrecise) {
            
            switch touchTargetTouchSource {
            case .preciseMagnifiedBox:
                if jiggleDocument.attemptSelectNeighborJiggleControlPoint_PreciseMagnified(touches: touches,
                                                                                           points: points,
                                                                                           selectedJiggle: _selectedJiggle,
                                                                                           selectedJiggleControlPoint: _selectedJiggleControlPoint,
                                                                                           displayMode: displayMode,
                                                                                           isGraphEnabled: isGraphEnabled) {
                    
                    if isResetPreciseMagnifiedBoxActive == false && isResetPreciseDistantBoxActive == false {
                        animatePreciseBoxFromSomethingChanged()
                    }
                }
            default:
                break
            }
        }
    }
    
    @MainActor func attemptGrabJiggleControlPointTanHandle(touches: [UITouch],
                                                           points: [Point],
                                                           touchTargetTouchSource: TouchTargetTouchSource) {
        
        if isAnimatingTouchArea(touchTargetTouchSource: touchTargetTouchSource) {
            print("We're animating in \(touchTargetTouchSource), stopping grab")
            return
        }
        
        let _selectedJiggle = jiggleDocument.getSelectedJiggle()
        let _selectedJiggleControlPoint = jiggleDocument.getSelectedJiggleControlPoint()
        
        //TODO: Test
        if jiggleDocument.isUnifyTangentsEnabled {
            if jiggleDocument.attemptSelectNeighborJiggleControlPointTanHandle_PreciseMagnified(touches: touches,
                                                                                                points: points,
                                                                                                selectedJiggle: _selectedJiggle,
                                                                                                selectedJiggleControlPoint: _selectedJiggleControlPoint,
                                                                                                displayMode: displayMode,
                                                                                                isGraphEnabled: isGraphEnabled) {
                
                print("This is a valid neighbor selection toch")
                
            }
            return
        }
        
        
        
        if !jiggleDocument.attemptGrabJiggleControlPointTanHandle(jiggleViewModel: self,
                                                                  touches: touches,
                                                                  points: points,
                                                                  displayMode: displayMode,
                                                                  isGraphEnabled: isGraphEnabled,
                                                                  touchTargetTouchSource: touchTargetTouchSource,
                                                                  isPrecise: isRenderingPrecise) {
            
            switch touchTargetTouchSource {
            case .preciseMagnifiedBox:
                if jiggleDocument.attemptSelectNeighborJiggleControlPointTanHandle_PreciseMagnified(touches: touches,
                                                                                                    points: points,
                                                                                                    selectedJiggle: _selectedJiggle,
                                                                                                    selectedJiggleControlPoint: _selectedJiggleControlPoint,
                                                                                                    displayMode: displayMode,
                                                                                                    isGraphEnabled: isGraphEnabled) {
                    
                    if isResetPreciseMagnifiedBoxActive == false && isResetPreciseDistantBoxActive == false {
                        animatePreciseBoxFromSomethingChanged()
                    }
                }
            default:
                break
            }
            
        }
    }
    
    @MainActor func attemptGrabJiggleControlPointOrTan(touches: [UITouch],
                                                       points: [Point],
                                                       touchTargetTouchSource: TouchTargetTouchSource) {
        
        if isAnimatingTouchArea(touchTargetTouchSource: touchTargetTouchSource) {
            print("We're animating in \(touchTargetTouchSource), stopping grab")
            return
        }
        
        
        let _selectedJiggle = jiggleDocument.getSelectedJiggle()
        let _selectedJiggleControlPoint = jiggleDocument.getSelectedJiggleControlPoint()
        
        //TODO: Test
        if jiggleDocument.isUnifyTangentsEnabled {
            if jiggleDocument.attemptSelectNeighborJiggleControlPointOrTan_PreciseMagnified(touches: touches,
                                                                                            points: points,
                                                                                            selectedJiggle: _selectedJiggle,
                                                                                            selectedJiggleControlPoint: _selectedJiggleControlPoint,
                                                                                            displayMode: displayMode,
                                                                                            isGraphEnabled: isGraphEnabled) {
                
                print("This is a valid neighbor selection toch")
                
            }
            return
        }
        
        
        
        if !jiggleDocument.attemptGrabJiggleControlPointOrTan(jiggleViewModel: self,
                                                              touches: touches,
                                                              points: points,
                                                              displayMode: displayMode,
                                                              isGraphEnabled: isGraphEnabled,
                                                              touchTargetTouchSource: touchTargetTouchSource,
                                                              isPrecise: isRenderingPrecise) {
            switch touchTargetTouchSource {
            case .preciseMagnifiedBox:
                if jiggleDocument.attemptSelectNeighborJiggleControlPointOrTan_PreciseMagnified(touches: touches,
                                                                                                points: points,
                                                                                                selectedJiggle: _selectedJiggle,
                                                                                                selectedJiggleControlPoint: _selectedJiggleControlPoint,
                                                                                                displayMode: displayMode,
                                                                                                isGraphEnabled: isGraphEnabled) {
                    
                    if isResetPreciseMagnifiedBoxActive == false && isResetPreciseDistantBoxActive == false {
                        animatePreciseBoxFromSomethingChanged()
                    }
                }
            default:
                break
            }
            
        }
    }
    
    @MainActor func attemptGrabGuideControlPointTanHandle(touches: [UITouch],
                                                          points: [Point],
                                                          touchTargetTouchSource: TouchTargetTouchSource) {
        
        if isAnimatingTouchArea(touchTargetTouchSource: touchTargetTouchSource) {
            print("We're animating in \(touchTargetTouchSource), stopping grab")
            return
        }
        
        jiggleDocument.attemptGrabGuideControlPointTanHandle(jiggleViewModel: self,
                                                             touches: touches,
                                                             points: points,
                                                             displayMode: displayMode,
                                                             isGraphEnabled: isGraphEnabled,
                                                             touchTargetTouchSource: touchTargetTouchSource,
                                                             isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptGrabGuidePoint(touches: [UITouch],
                                          points: [Point],
                                          touchTargetTouchSource: TouchTargetTouchSource) {
        
        if isAnimatingTouchArea(touchTargetTouchSource: touchTargetTouchSource) {
            print("We're animating in \(touchTargetTouchSource), stopping grab")
            return
        }
        
        jiggleDocument.attemptGrabGuidePoint(jiggleViewModel: self,
                                             touches: touches,
                                             points: points,
                                             displayMode: displayMode,
                                             isGraphEnabled: isGraphEnabled,
                                             touchTargetTouchSource: touchTargetTouchSource,
                                             isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptGrabGuidePointOrTan(touches: [UITouch],
                                               points: [Point],
                                               touchTargetTouchSource: TouchTargetTouchSource) {
        
        if isAnimatingTouchArea(touchTargetTouchSource: touchTargetTouchSource) {
            print("We're animating in \(touchTargetTouchSource), stopping grab")
            return
        }
        
        jiggleDocument.attemptGrabGuidePointOrTan(jiggleViewModel: self,
                                                  touches: touches,
                                                  points: points,
                                                  displayMode: displayMode,
                                                  isGraphEnabled: isGraphEnabled,
                                                  touchTargetTouchSource: touchTargetTouchSource,
                                                  isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptUpdateControlPoint(touch: UITouch,
                                              point: Point,
                                              isFromRelease: Bool) {
        jiggleDocument.attemptUpdateControlPoint(jiggleViewModel: self,
                                                 touch: touch,
                                                 point: point,
                                                 isFromRelease: isFromRelease,
                                                 displayMode: displayMode,
                                                 isGraphEnabled: isGraphEnabled,
                                                 isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptUpdateJiggleControlPointTanHandle(touch: UITouch,
                                                             point: Point,
                                                             isFromRelease: Bool) {
        jiggleDocument.attemptUpdateJiggleControlPointTanHandle(jiggleViewModel: self,
                                                                touch: touch,
                                                                point: point,
                                                                isFromRelease: isFromRelease,
                                                                displayMode: displayMode,
                                                                isGraphEnabled: isGraphEnabled,
                                                                isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptUpdateGuidePoint(touch: UITouch,
                                            point: Point,
                                            isFromRelease: Bool) {
        jiggleDocument.attemptUpdateGuidePoint(jiggleViewModel: self,
                                               touch: touch,
                                               point: point,
                                               isFromRelease: isFromRelease,
                                               displayMode: displayMode,
                                               isGraphEnabled: isGraphEnabled,
                                               isPrecise: isRenderingPrecise)
    }
    
    
    @MainActor func attemptUpdateGuideControlPointTanHandle(touch: UITouch,
                                                            point: Point,
                                                            isFromRelease: Bool) {
        jiggleDocument.attemptUpdateGuideControlPointTanHandle(jiggleViewModel: self,
                                                               touch: touch,
                                                               point: point,
                                                               isFromRelease: isFromRelease,
                                                               displayMode: displayMode,
                                                               isGraphEnabled: isGraphEnabled,
                                                               isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptGrabWeightCenter(touches: [UITouch],
                                            points: [Point],
                                            touchTargetTouchSource: TouchTargetTouchSource) {
        jiggleDocument.attemptGrabWeightCenter(jiggleViewModel: self,
                                               touches: touches,
                                               points: points,
                                               displayMode: displayMode,
                                               isGraphEnabled: isGraphEnabled,
                                               touchTargetTouchSource: touchTargetTouchSource,
                                               isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptUpdateWeightCenter(touch: UITouch,
                                              point: Point,
                                              isFromRelease: Bool) {
        jiggleDocument.attemptUpdateWeightCenter(jiggleViewModel: self,
                                                 touch: touch,
                                                 point: point,
                                                 isFromRelease: isFromRelease)
    }
    
    @MainActor func attemptReleaseWeightCenter(touch: UITouch,
                                               point: Point) {
        jiggleDocument.attemptReleaseWeightCenter(jiggleViewModel: self,
                                                  touch: touch,
                                                  point: point)
    }
    
    @MainActor func attemptGrabJiggleCenter(touches: [UITouch],
                                            points: [Point],
                                            touchTargetTouchSource: TouchTargetTouchSource) {
        jiggleDocument.attemptGrabJiggleCenter(jiggleViewModel: self,
                                               touches: touches,
                                               points: points,
                                               displayMode: displayMode,
                                               touchTargetTouchSource: touchTargetTouchSource,
                                               isGraphEnabled: isGraphEnabled,
                                               isPrecise: isRenderingPrecise)
    }
    
    @MainActor func attemptUpdateJiggleCenter(touch: UITouch,
                                              point: Point,
                                              isFromRelease: Bool) {
        jiggleDocument.attemptUpdateJiggleCenter(jiggleViewModel: self,
                                                 touch: touch,
                                                 point: point,
                                                 isFromRelease: isFromRelease)
    }
    
    @MainActor func attemptReleaseJiggleCenter(touch: UITouch,
                                               point: Point) {
        jiggleDocument.attemptReleaseJiggleCenter(jiggleViewModel: self,
                                                  touch: touch,
                                                  point: point)
    }
    
    @MainActor func killDragAll(killDragReleaseSource: KillDragReleaseSource) {
        jiggleDocument.killDragAll(jiggleViewModel: self,
                                   killDragReleaseSource: killDragReleaseSource)
        killDragSwivel()
    }
    
    @MainActor func killDragNormal(killDragReleaseSource: KillDragReleaseSource) {
        jiggleDocument.killDragNormal(killDragReleaseSource: killDragReleaseSource)
    }
    
    @MainActor func killDragPrecise(killDragReleaseSource: KillDragReleaseSource) {
        jiggleDocument.killDragPrecise(killDragReleaseSource: killDragReleaseSource)
    }
    
    @MainActor func killDragSwivel() {
        swivelCoordinator.allTouchesWereCancelled(jiggle: getSelectedJiggle())
    }
    
    func getWorldScale(isPrecise: Bool) -> Float {
        var result = Float(1.0)
        if fabsf(jiggleScene.normalBoxScale) > Math.epsilon {
            result = (1.0 / jiggleScene.normalBoxScale)
        }
        return result
    }
    
    @MainActor func graphUpdateRelay() {
        if let jiggleViewController = jiggleViewController {
            jiggleViewController.graphUpdateRelay(jiggle: getSelectedJiggle())
        }
    }
    
    @MainActor func timeLineUpdateRelay() {
        if let jiggleViewController = jiggleViewController {
            jiggleViewController.timeLineUpdateRelay(jiggle: getSelectedJiggle())
        }
    }
    
    @MainActor func handleWakeUpBegin() {
        jiggleDocument.handleWakeUpBegin(jiggleEngine: jiggleEngine,
                                         displayMode: displayMode,
                                         isGraphEnabled: isGraphEnabled,
                                         jiggleScene: jiggleScene,
                                         isPrecise: isRenderingPrecise)
    }
    
    @MainActor func handleWakeUpComplete_PartA() {
        jiggleDocument.handleWakeUpComplete_PartA(jiggleEngine: jiggleEngine,
                                                  displayMode: displayMode,
                                                  isGraphEnabled: isGraphEnabled)
        refreshAllTimeLines()
    }
    
    @MainActor func handleWakeUpComplete_PartB() {
        handleAnimationModeDidChange()
        handleJigglesDidChange()
        handleDocumentModeDidChange()
        jiggleDocument.handleWakeUpComplete_PartB(jiggleEngine: jiggleEngine,
                                                  displayMode: displayMode,
                                                  isGraphEnabled: isGraphEnabled)
        jiggleDocument.isWakeUpComplete = true
    }
    
    @MainActor func handleExit() {
        jiggleDocument.handleExit()
    }
    
    @MainActor func handleAnimationModeDidChange() {
        jiggleDocument.handleAnimationModeDidChange(jiggleViewModel: self)
    }
    
    @MainActor func handleJigglesDidChange() {
        jiggleDocument.handleJigglesDidChange(jiggleViewModel: self)
    }
    
    @MainActor func handleDocumentModeDidChange() {
        jiggleDocument.handleDocumentModeDidChange(jiggleViewModel: self)
    }
    
    @MainActor func applicationWillResignActive() {
        jiggleDocument.applicationWillResignActive(jiggleViewModel: self)
    }
    
    @MainActor func applicationDidBecomeActive() {
        jiggleDocument.applicationDidBecomeActive()
    }
    
    @MainActor func handleDarkModeDidChange() {
        jiggleDocument.handleDarkModeDidChange()
    }
    
}
