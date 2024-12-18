//
//  AnimusInstructionGrab.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 12/7/24.
//

import Foundation

class AnimusInstructionGrab {
    
    var testflingMult = Float(0.0)
    
    static let overweightTimeLimit = Float(0.075)
    
    static let flingLargePhone_000 = Float(0.43721876)
    static let flingLargePhone_025 = Float(0.74833775)
    static let flingLargePhone_050 = Float(0.8921888)
    static let flingLargePhone_075 = Float(0.97450274)
    static let flingLargePhone_100 = Float(1.0308849)
    
    static let flingMediumPhone_000 = Float(0.44604832)
    static let flingMediumPhone_025 = Float(0.7766216)
    static let flingMediumPhone_050 = Float(0.9285125)
    static let flingMediumPhone_075 = Float(1.015327)
    static let flingMediumPhone_100 = Float(1.0747646)
    
    static let flingSmallPhone_000 = Float(0.4608757)
    static let flingSmallPhone_025 = Float(0.82453537)
    static let flingSmallPhone_050 = Float(0.9900773)
    static let flingSmallPhone_075 = Float(1.0845323)
    static let flingSmallPhone_100 = Float(1.1491463)
    
    static let flingLargePad_000 = Float(0.47225678)
    static let flingLargePad_025 = Float(0.8203307)
    static let flingLargePad_050 = Float(0.9812279)
    static let flingLargePad_075 = Float(1.0733016)
    static let flingLargePad_100 = Float(1.1363759)
    
    static let flingMediumPad_000 = Float(0.49242094)
    static let flingMediumPad_025 = Float(0.86781204)
    static let flingMediumPad_050 = Float(1.0402796)
    static let flingMediumPad_075 = Float(1.1388471)
    static let flingMediumPad_100 = Float(1.2063453)
    
    static let flingSmallPad_000 = Float(0.529457)
    static let flingSmallPad_025 = Float(0.9540771)
    static let flingSmallPad_050 = Float(1.1473556)
    static let flingSmallPad_075 = Float(1.2576535)
    static let flingSmallPad_100 = Float(1.3330941)
    
    static let gyroLargePhone_000 = Float(0.818)
    static let gyroLargePhone_025 = Float(0.225)
    static let gyroLargePhone_050 = Float(0.168)
    static let gyroLargePhone_075 = Float(0.129)
    static let gyroLargePhone_100 = Float(0.117)
    
    static let gyroMediumPhone_000 = Float(0.678)
    static let gyroMediumPhone_025 = Float(0.195)
    static let gyroMediumPhone_050 = Float(0.133)
    static let gyroMediumPhone_075 = Float(0.115)
    static let gyroMediumPhone_100 = Float(0.108)
    
    static let gyroSmallPhone_000 = Float(0.514)
    static let gyroSmallPhone_025 = Float(0.176)
    static let gyroSmallPhone_050 = Float(0.113)
    static let gyroSmallPhone_075 = Float(0.107)
    static let gyroSmallPhone_100 = Float(0.105)
    
    static let gyroLargePad_000 = Float(0.382)
    static let gyroLargePad_025 = Float(0.192)
    static let gyroLargePad_050 = Float(0.159)
    static let gyroLargePad_075 = Float(0.140)
    static let gyroLargePad_100 = Float(0.140)
    
    static let gyroMediumPad_000 = Float(0.371)
    static let gyroMediumPad_025 = Float(0.186)
    static let gyroMediumPad_050 = Float(0.153)
    static let gyroMediumPad_075 = Float(0.138)
    static let gyroMediumPad_100 = Float(0.129)
    
    static let gyroSmallPad_000 = Float(0.359)
    static let gyroSmallPad_025 = Float(0.180)
    static let gyroSmallPad_050 = Float(0.141)
    static let gyroSmallPad_075 = Float(0.135)
    static let gyroSmallPad_100 = Float(0.120)
    
    
    // Note: I am deciding right now. This number, 32, doesn't change.
    //       All the rest of the values hinge on this and it's arbitrary.
    //       There's not ever any reason to change it.
    static let STEP_COUNT = 32
    static let STEP_COUNTF = Float(STEP_COUNT)
    
    var cursorSpeedX = Float(0.0)
    var cursorSpeedY = Float(0.0)
    var cursorElastic = Float(0.0)
    var cursorGyroSleepTime = Float(0.5)
    
    var overweightTime = Float(0.0)
    
    var BIGGEST_GYRO = Float(0.0)
    var BIGGEST_FLING = Float(0.0)
    
    func deactivate() {
        print("AnimusInstructionGrab => deactivate")
    }
    
    func activate() {
        print("AnimusInstructionGrab => activate")
    }
    
    // No knowledge of meme bag.
    // It operates on a command, and the list of active touches...
    let pointerBag = AnimusTouchPointerBag(format: .grab)
    let memeBag = AnimusTouchMemeBag(format: .grab)
    
    init() {
        
    }
    
    func update_Inactive(deltaTime: Float) {
        pointerBag.update(deltaTime: deltaTime)
    }
    
    var prevX1: Float = 0.0
    var prevX2: Float = 0.0
    var prevY1: Float = 0.0
    var prevY2: Float = 0.0
    
    var isHandHeld = false
    var sturtDis = Float(0.0)
    var WW_DA_GYRO_MULT = Float(0.0)
    var sum_speed_1 = Float(0.0)
    var sum_speed_2 = Float(0.0)
    var MY_MAGIC_EXIFF_DATA = Float(0.0)
    
    
    func update_Active(deltaTime: Float,
                       jiggleDocument: JiggleDocument,
                       jiggle: Jiggle,
                       isGyroEnabled: Bool,
                       clock: Float) {
        
        pointerBag.update(deltaTime: deltaTime)
        
        
        let measurePercentLinear = Jiggle.getMeasurePercentLinear(measuredSize: jiggle.measuredSize)
        let distanceR2 = Jiggle.getAnimationCursorFalloffDistance_R2(measurePercentLinear: measurePercentLinear)
        
        if !jiggle.isCaptureActiveGrab {
            
            
            
            
            
            //let test01 = Math.percentThroughRange(value: jiggle.userGyroPowerAmount, minimum: Jiggle.userGyroPowerAmountMin, maximum: Jiggle.userGyroPowerAmountMax)
            //let test02 = Math.percentThroughRange(value: jiggle.userJiggleSpeedAmount, minimum: Jiggle.userJiggleSpeedAmountMin, maximum: Jiggle.userJiggleSpeedAmountMax)
            //let test03 = Math.percentThroughRange(value: jiggle.jiggleDampenAmount, minimum: Jiggle.jiggleDampenAmountMin, maximum: Jiggle.jiggleDampenAmountMax)
            
            //print("test01 = \(test01) | test02 = \(test02) | test03 = \(test03)")
            
            let grabDragSpeedPercentLinear = Jiggle.getGrabDragSpeedPercentLinear(userGrabDragSpeed: jiggle.grabSpeed)
            let grabDragStiffnessPercentLinear = Jiggle.getGrabDragStiffnessPercentLinear(userGrabDragStiffness: jiggle.grabStiffness)
            
            var cursorX = jiggle.animationCursorX
            var cursorY = jiggle.animationCursorY
            
            let gyroX = ApplicationController.gyroSmoothX
            let gyroY = ApplicationController.gyroSmoothY
            
            let gyroDirX: Float
            let gyroDirY: Float
            let gyroLengthSquared = gyroX * gyroX + gyroY * gyroY
            let gyroLength: Float
            if gyroLengthSquared > Math.epsilon {
                gyroLength = sqrtf(gyroLengthSquared)
                gyroDirX = gyroX / gyroLength
                gyroDirY = gyroY / gyroLength
            } else {
                gyroLength = 0.0
                gyroDirX = 0.0
                gyroDirY = 0.0
                
            }
            
            
            
            
            
            // These are pretty much grand fathered in by the data capture session...
            let gyroMaxLength: Float
            let gyroMinLength: Float
            if Device.isPad {
                gyroMinLength = 0.26
                gyroMaxLength = 6.8
            } else {
                gyroMinLength = 0.34
                gyroMaxLength = 9.0
            }
            var gyroLengthPercent = (gyroLength - gyroMinLength) / (gyroMaxLength - gyroMinLength)
            if gyroLengthPercent > 1.0 { gyroLengthPercent = 1.0 }
            if gyroLengthPercent < 0.0 { gyroLengthPercent = 0.0 }
            
            
            
            
            
            let fractionPerStep = deltaTime / AnimusInstructionGrab.STEP_COUNTF
            
            
            //let stiffnessMultiplierPerStep = powf(fractionalStiffnessMultiplier, deltaTime)
            
            //let fractionalDamperMultiplier = powf(0.25 + test03 * 0.75, deltaTime / AnimusInstructionGrab.STEP_COUNTF)
            
            //4068 (large, fast)
            //2940 (small, fast)
            
            // 244 (large, slow)
            // 136 (small, slow)
            
            
            // What we noticed is that the mid-point on drag is
            // not fast enough, so we want to skew the middle towards high.
            let grabDragSpeedPercent = Math.mixPercentCubicOpposite(percent: grabDragSpeedPercentLinear, linearFactor: 0.5)
            
            // 5600.0
            
            //TODO: We may want to remove the 2.5 multiplier and just let the
            //      slowet jiggles be slow. In some wild phone swinging case, it
            //      will go far out of range, but it's not life ruining...
            //
            let speedHi = 3218.0 + (5640.0 - 3218.0) * measurePercentLinear
            
            //let speedLo = (144.0 * 2.0) + ((276.0 * 2.0) - (144.0 * 2.0)) * measurePercentLinear
            
            // Calibration speed...
            let speedLo = (144.0 * 3.0) + ((276.0 * 3.0) - (144.0 * 3.0)) * measurePercentLinear
            
            let speed = speedLo + (speedHi - speedLo) * grabDragSpeedPercent
            
            let gyroMultiplierLarge: Float
            let gyroMultiplierMedium: Float
            let gyroMultiplierSmall: Float
            
            if Device.isPhone {
                gyroMultiplierLarge = Math.interpolate5(inputMin: 0.0,
                                                        inputMid1: 0.25,
                                                        inputMid2: 0.5,
                                                        inputMid3: 0.75,
                                                        inputMax: 1.0,
                                                        input: grabDragSpeedPercent,
                                                        outputMin: Self.gyroLargePhone_000,
                                                        outputMid1: Self.gyroLargePhone_025,
                                                        outputMid2: Self.gyroLargePhone_050,
                                                        outputMid3: Self.gyroLargePhone_075,
                                                        outputMax: Self.gyroLargePhone_100)
                
                gyroMultiplierMedium = Math.interpolate5(inputMin: 0.0,
                                                         inputMid1: 0.25,
                                                         inputMid2: 0.5,
                                                         inputMid3: 0.75,
                                                         inputMax: 1.0,
                                                         input: grabDragSpeedPercent,
                                                         outputMin: Self.gyroMediumPhone_000,
                                                         outputMid1: Self.gyroMediumPhone_025,
                                                         outputMid2: Self.gyroMediumPhone_050,
                                                         outputMid3: Self.gyroMediumPhone_075,
                                                         outputMax: Self.gyroMediumPhone_100)
                
                gyroMultiplierSmall = Math.interpolate5(inputMin: 0.0,
                                                        inputMid1: 0.25,
                                                        inputMid2: 0.5,
                                                        inputMid3: 0.75,
                                                        inputMax: 1.0,
                                                        input: grabDragSpeedPercent,
                                                        outputMin: Self.gyroSmallPhone_000,
                                                        outputMid1: Self.gyroSmallPhone_025,
                                                        outputMid2: Self.gyroSmallPhone_050,
                                                        outputMid3: Self.gyroSmallPhone_075,
                                                        outputMax: Self.gyroSmallPhone_100)
                
            } else {
                gyroMultiplierLarge = Math.interpolate5(inputMin: 0.0,
                                                        inputMid1: 0.25,
                                                        inputMid2: 0.5,
                                                        inputMid3: 0.75,
                                                        inputMax: 1.0,
                                                        input: grabDragSpeedPercent,
                                                        outputMin: Self.gyroLargePad_000,
                                                        outputMid1: Self.gyroLargePad_025,
                                                        outputMid2: Self.gyroLargePad_050,
                                                        outputMid3: Self.gyroLargePad_075,
                                                        outputMax: Self.gyroLargePad_100)
                
                gyroMultiplierMedium = Math.interpolate5(inputMin: 0.0,
                                                         inputMid1: 0.25,
                                                         inputMid2: 0.5,
                                                         inputMid3: 0.75,
                                                         inputMax: 1.0,
                                                         input: grabDragSpeedPercent,
                                                         outputMin: Self.gyroMediumPad_000,
                                                         outputMid1: Self.gyroMediumPad_025,
                                                         outputMid2: Self.gyroMediumPad_050,
                                                         outputMid3: Self.gyroMediumPad_075,
                                                         outputMax: Self.gyroMediumPad_100)
                
                gyroMultiplierSmall = Math.interpolate5(inputMin: 0.0,
                                                        inputMid1: 0.25,
                                                        inputMid2: 0.5,
                                                        inputMid3: 0.75,
                                                        inputMax: 1.0,
                                                        input: grabDragSpeedPercent,
                                                        outputMin: Self.gyroSmallPad_000,
                                                        outputMid1: Self.gyroSmallPad_025,
                                                        outputMid2: Self.gyroSmallPad_050,
                                                        outputMid3: Self.gyroSmallPad_075,
                                                        outputMax: Self.gyroSmallPad_100)
            }
            
            let gyroMultiplier = Math.interpolate3(inputMin: Jiggle.minMeasuredSize,
                                                   inputMid: Jiggle.midMeasuredSize,
                                                   inputMax: Jiggle.maxMeasuredSize,
                                                   input: jiggle.measuredSize,
                                                   outputMin: gyroMultiplierSmall,
                                                   outputMid: gyroMultiplierMedium,
                                                   outputMax: gyroMultiplierLarge)
            
            
            
            //let gyroMultiplierRange = (gyroMultiplier_SizeLarge - gyroMultiplier_SizeSmall)
            //let gyroMultiplier = gyroMultiplier_SizeSmall + gyroMultiplierRange * measurePercentLinear
            
            
            // Not slow:
            //let gyroMultiplier = Float(0.0 + test01 * 0.2)
            
            
            // 50 slow slow:
            //let gyroMultiplier = Float(0.05 + test01 * 0.3)
            
            
            // 0 slow slow:
            //let gyroMultiplier = Float(0.275 + test01 * 0.2)
            
            
            /*
             let gyroMultiplier = Math.interpolate5(inputMin: 0.0,
             inputMid1: 0.25,
             inputMid2: 0.5,
             inputMid3: 0.75,
             inputMax: 1.0,
             input: grabDragSpeedPercent,
             outputMin: Self.gyroLargePhone_000,
             outputMid1: Self.gyroLargePhone_025,
             outputMid2: Self.gyroLargePhone_050,
             outputMid3: Self.gyroLargePhone_075,
             outputMax: Self.gyroLargePhone_100)
             
             print("gyroMultiplier = \(gyroMultiplier)")
             */
            
            
            //static let gyroLargePhone_000 = Float(1.5175)
            //static let gyroLargePhone_025 = Float(0.250)
            //static let gyroLargePhone_050 = Float(0.17475)
            //static let gyroLargePhone_075 = Float(0.13125)
            //static let gyroLargePhone_100 = Float(0.1165)
            
            
            
            
            
            
            //print("gyroMultiplier = \(gyroMultiplier)")
            
            WW_DA_GYRO_MULT = gyroMultiplier
            
            
            // iPad, high speed, large jiggle => 0.155
            // iPad, low speed, large jiggle => 0.0675
            // iPad, high speed, small jiggle => 0.1175
            // iPad, high speed, small jiggle => 0.0725
            
            
            
            
            // What we noticed is that in the middle, it makes
            // more sense for the elasticity to be lower. E.G.
            // quicker jiggles by default. Too long is bad.
            let cursorElasticRangePercent = Math.mixPercentCubic(percent: grabDragStiffnessPercentLinear, linearFactor: 0.3)
            
            let cursorElasticMin = Float(0.0)
            let cursorElasticMax = Float(0.12) + cursorElasticRangePercent * 2.76
            let cursorElasticRange = (cursorElasticMax - cursorElasticMin)
            
            let deltaTime_Count = (deltaTime / AnimusInstructionGrab.STEP_COUNTF)
            
            for stepIndex in 0..<AnimusInstructionGrab.STEP_COUNT {
                
                var diffX1 = -cursorX
                var diffY1 = -cursorY
                
                let distanceSquared1 = diffX1 * diffX1 + diffY1 * diffY1
                let distance1: Float
                if distanceSquared1 > Math.epsilon {
                    distance1 = sqrtf(distanceSquared1)
                    diffX1 /= distance1
                    diffY1 /= distance1
                } else {
                    diffX1 = 0.0
                    diffY1 = 0.0
                    distance1 = 0.0
                }
                
                
                
                
                if distance1 > BIGGEST_GYRO {
                    BIGGEST_GYRO = distance1
                }
                if distance1 > BIGGEST_FLING {
                    BIGGEST_FLING = distance1
                }
                
                
                
                
                
                let moveAmount = speed * fractionPerStep
                
                // Whether this is sine or linear...
                // If it's sine, it seems to speed up the jiggle.
                // If it's sine, it seems to hang slightly more at the extremes of the motion.
                let percentAwayFromCenterLinear = distance1 / distanceR2
                let percentAwayFromCenterLinearInverse = (1.0 - percentAwayFromCenterLinear)
                let percentAwayFromCenter = Math.mixPercentSin(percent: percentAwayFromCenterLinear, linearFactor: 0.4)
                
                cursorElastic += fractionPerStep
                if cursorElastic > cursorElasticMax {
                    cursorElastic = cursorElasticMax
                }
                
                
                let gyroPercentLinear = percentAwayFromCenterLinearInverse
                //let gyroPercent = Math.mixPercentSin(percent: gyroPercentLinear, linearFactor: 0.3)
                let gyroPercent = Math.mixPercentQuadratic(percent: gyroPercentLinear, linearFactor: 0.5)
                
                
                if true {
                    
                    // Pretty much, while we're shaking the device
                    // around, it becomes like we just started again.
                    cursorElastic -= gyroLengthPercent * 12.0 * fractionPerStep
                    if cursorElastic < 0.0 {
                        cursorElastic = 0.0
                    }
                    
                    //cursorSpeedX += gyroDirX * gyroLength * gyroPercent * moveAmount * gyroMultiplier
                    //cursorSpeedY += gyroDirY * gyroLength * gyroPercent * moveAmount * gyroMultiplier
                    cursorX += gyroDirX * gyroLength * gyroPercent * moveAmount * gyroMultiplier
                    cursorY += gyroDirY * gyroLength * gyroPercent * moveAmount * gyroMultiplier
                    
                }
                
                sum_speed_1 += cursorSpeedX
                sum_speed_2 += cursorSpeedY
                
                
                let cursorElasticPercentLinear = (cursorElastic - cursorElasticMin) / cursorElasticRange
                let cursorElasticPercent = Math.mixPercentSin(percent: cursorElasticPercentLinear, linearFactor: 0.4)
                
                cursorSpeedX += diffX1 * moveAmount * percentAwayFromCenter
                cursorSpeedY += diffY1 * moveAmount * percentAwayFromCenter
                cursorX += cursorSpeedX * deltaTime
                cursorY += cursorSpeedY * deltaTime
                
                
                //
                // This number works fine. Please do not change it any more.
                // Per the tests, it hardly matters which numbers we pick.
                //
                // Without this, it takes impossibly long for the animation
                // to stop playing, so you need it for sure.
                //
                let fractionalStiffnessMultiplier = powf(0.48 - 0.44 * cursorElasticPercent, deltaTime_Count)
                cursorSpeedX *= fractionalStiffnessMultiplier
                cursorSpeedY *= fractionalStiffnessMultiplier
                
                
                //
                // This number works fine. Please do not change it any more.
                // Per the tests, it hardly matters which numbers we pick...
                //
                
                let counterForcePercent = Math.mixPercentSin(percent: percentAwayFromCenterLinearInverse, linearFactor: 0.4)
                
                var diffX2 = -cursorX
                var diffY2 = -cursorY
                let distanceSquared2 = diffX2 * diffX2 + diffY2 * diffY2
                let distance2: Float
                if distanceSquared2 > Math.epsilon {
                    distance2 = sqrtf(distanceSquared2)
                    diffX2 /= distance2
                    diffY2 /= distance2
                } else {
                    diffX2 = 0.0
                    diffY2 = 0.0
                    distance2 = 0.0
                }
                
                if distance2 > BIGGEST_GYRO {
                    BIGGEST_GYRO = distance2
                }
                if distance2 > BIGGEST_FLING {
                    BIGGEST_FLING = distance2
                }
                
                //
                // This number works fine. Please do not change it any more.
                // Per the tests, it hardly matters which numbers we pick...
                //
                var counterStepLength = moveAmount * 0.4 * counterForcePercent
                if counterStepLength > distance2 {
                    counterStepLength = distance2
                }
                cursorX += diffX2 * counterStepLength * deltaTime
                cursorY += diffY2 * counterStepLength * deltaTime
                
                
                /*
                 var shouldPrintData = false
                 if isHandHeld {
                 shouldPrintData = true
                 sturtDis = sqrtf(cursorX * cursorX + cursorY * cursorY)
                 
                 prevX2 = cursorX
                 prevX1 = cursorX
                 prevY2 = cursorY
                 prevY1 = cursorY
                 }
                 
                 var isXMaxima = false
                 var isYMaxima = false
                 
                 if prevX1 > prevX2 && cursorX < prevX1 {
                 isXMaxima = true
                 }
                 if prevX1 < prevX2 && cursorX > prevX1 {
                 isXMaxima = true
                 }
                 if prevY1 > prevY2 && cursorY < prevY1 {
                 isYMaxima = true
                 }
                 if prevY1 < prevY2 && cursorY > prevY1 {
                 isYMaxima = true
                 }
                 
                 if isYMaxima || isXMaxima {
                 print("maximas x: \(isXMaxima), y: \(isYMaxima) isHandHeld = \(isHandHeld)")
                 shouldPrintData = true
                 }
                 
                 if shouldPrintData {
                 let divvx = cursorX * cursorX + cursorY * cursorY
                 let dis = sqrtf(divvx)
                 print("Distance = \(dis) PCT: \(dis / sturtDis) (Start = \(sturtDis)) CEP = \(cursorElasticPercentLinear * 1000.0)")
                 }
                 */
                
                
                prevX2 = prevX1
                prevX1 = cursorX
                prevY2 = prevY1
                prevY1 = cursorY
                
                isHandHeld = false
            }
            
            jiggle.animationCursorX = cursorX
            jiggle.animationCursorY = cursorY
            
        } else {
            
            cursorSpeedX = Float(0.0)
            cursorSpeedY = Float(0.0)
            cursorElastic = Float(0.0)
            
            isHandHeld = true
            prevX2 = jiggle.animationCursorX
            prevX1 = jiggle.animationCursorX
            prevY2 = jiggle.animationCursorY
            prevY1 = jiggle.animationCursorY
        }
        
        
        var distance_R1_Adjusted = Float(0.0)
        var distance_R2_Adjusted = Float(0.0)
        Jiggle.getAnimationCursorFalloffDistance_Radii(measuredSize: jiggle.measuredSize,
                                                       userGrabDragPower: jiggle.grabDragPower,
                                                       distance_R1: &distance_R1_Adjusted,
                                                       distance_R2: &distance_R2_Adjusted)
        
        
        let overweightDistance = distance_R2_Adjusted * 0.975
        
        let diffX = jiggle.animationCursorX
        let diffY = jiggle.animationCursorY
        let distanceSquared = diffX * diffX + diffY * diffY
        let distance: Float
        if distanceSquared > Math.epsilon {
            distance = sqrtf(distanceSquared)
        } else {
            distance = 0.0
        }
        
        if distance > overweightDistance {
            overweightTime += deltaTime
        } else {
            overweightTime = 0.0
        }
        
    }
    
    // Unconstrained power
    func fling(jiggle: Jiggle,
               powerX: Float,
               powerY: Float) {
        
        if overweightTime > Self.overweightTimeLimit {
            //print("Stifled Fling, overweightTime = \(overweightTime)")
        }
        
        let measurePercentLinear = Jiggle.getMeasurePercentLinear(measuredSize: jiggle.measuredSize)
        
        
        let grabDragSpeedPercentLinear = Jiggle.getGrabDragSpeedPercentLinear(userGrabDragSpeed: jiggle.grabSpeed)
        let grabDragSpeedPercent = Math.mixPercentCubicOpposite(percent: grabDragSpeedPercentLinear, linearFactor: 0.5)
        
        let distanceR1 = Jiggle.getAnimationCursorFalloffDistance_R1(measurePercentLinear: measurePercentLinear)
        let distanceR2 = Jiggle.getAnimationCursorFalloffDistance_R2(measurePercentLinear: measurePercentLinear)
        let distanceR3 = Jiggle.getAnimationCursorFalloffDistance_R3(measurePercentLinear: measurePercentLinear)
        
        
        var distance_R1_Adjusted = Float(0.0)
        var distance_R2_Adjusted = Float(0.0)
        var distance_R3_Adjusted = Float(0.0)
        
        Jiggle.getAnimationCursorFalloffDistance_Radii(measuredSize: jiggle.measuredSize,
                                                       userGrabDragPower: jiggle.grabDragPower,
                                                       distance_R1: &distance_R1_Adjusted,
                                                       distance_R2: &distance_R2_Adjusted,
                                                       distance_R3: &distance_R3_Adjusted)
        
        
        let diffX = jiggle.animationCursorX
        let diffY = jiggle.animationCursorY
        let distanceSquared = diffX * diffX + diffY * diffY
        let distance: Float
        if distanceSquared > Math.epsilon {
            distance = sqrtf(distanceSquared)
        } else {
            distance = 0.0
        }
        
        
        
        var stifle = Float(1.0)
        /*
         if distance > distance_R2_Adjusted {
         var percent = Math.percentThroughRange(value: distance, minimum: distance_R2_Adjusted, maximum: distance_R3_Adjusted)
         percent = Math.mixPercentQuadraticOpposite(percent: percent, linearFactor: 0.5)
         stifle = (1.0 - percent)
         }
         print("stifle = \(stifle)")
         */
        
        let magnitudeSquared = powerX * powerX + powerY * powerY
        if magnitudeSquared > Math.epsilon {
            
            let test01 = Math.percentThroughRange(value: jiggle.userGyroPowerAmount, minimum: Jiggle.userGyroPowerAmountMin, maximum: Jiggle.userGyroPowerAmountMax)
            
            
            // Non-zero
            
            
            
            let flingMultiplierLarge: Float
            let flingMultiplierMedium: Float
            let flingMultiplierSmall: Float
            
            if Device.isPhone {
                flingMultiplierLarge = Math.interpolate5(inputMin: 0.0,
                                                         inputMid1: 0.25,
                                                         inputMid2: 0.5,
                                                         inputMid3: 0.75,
                                                         inputMax: 1.0,
                                                         input: grabDragSpeedPercent,
                                                         outputMin: Self.flingLargePhone_000,
                                                         outputMid1: Self.flingLargePhone_025,
                                                         outputMid2: Self.flingLargePhone_050,
                                                         outputMid3: Self.flingLargePhone_075,
                                                         outputMax: Self.flingLargePhone_100)
                
                flingMultiplierMedium = Math.interpolate5(inputMin: 0.0,
                                                          inputMid1: 0.25,
                                                          inputMid2: 0.5,
                                                          inputMid3: 0.75,
                                                          inputMax: 1.0,
                                                          input: grabDragSpeedPercent,
                                                          outputMin: Self.flingMediumPhone_000,
                                                          outputMid1: Self.flingMediumPhone_025,
                                                          outputMid2: Self.flingMediumPhone_050,
                                                          outputMid3: Self.flingMediumPhone_075,
                                                          outputMax: Self.flingMediumPhone_100)
                
                flingMultiplierSmall = Math.interpolate5(inputMin: 0.0,
                                                         inputMid1: 0.25,
                                                         inputMid2: 0.5,
                                                         inputMid3: 0.75,
                                                         inputMax: 1.0,
                                                         input: grabDragSpeedPercent,
                                                         outputMin: Self.flingSmallPhone_000,
                                                         outputMid1: Self.flingSmallPhone_025,
                                                         outputMid2: Self.flingSmallPhone_050,
                                                         outputMid3: Self.flingSmallPhone_075,
                                                         outputMax: Self.flingSmallPhone_100)
                
            } else {
                flingMultiplierLarge = Math.interpolate5(inputMin: 0.0,
                                                         inputMid1: 0.25,
                                                         inputMid2: 0.5,
                                                         inputMid3: 0.75,
                                                         inputMax: 1.0,
                                                         input: grabDragSpeedPercent,
                                                         outputMin: Self.flingLargePad_000,
                                                         outputMid1: Self.flingLargePad_025,
                                                         outputMid2: Self.flingLargePad_050,
                                                         outputMid3: Self.flingLargePad_075,
                                                         outputMax: Self.flingLargePad_100)
                
                flingMultiplierMedium = Math.interpolate5(inputMin: 0.0,
                                                          inputMid1: 0.25,
                                                          inputMid2: 0.5,
                                                          inputMid3: 0.75,
                                                          inputMax: 1.0,
                                                          input: grabDragSpeedPercent,
                                                          outputMin: Self.flingMediumPad_000,
                                                          outputMid1: Self.flingMediumPad_025,
                                                          outputMid2: Self.flingMediumPad_050,
                                                          outputMid3: Self.flingMediumPad_075,
                                                          outputMax: Self.flingMediumPad_100)
                
                flingMultiplierSmall = Math.interpolate5(inputMin: 0.0,
                                                         inputMid1: 0.25,
                                                         inputMid2: 0.5,
                                                         inputMid3: 0.75,
                                                         inputMax: 1.0,
                                                         input: grabDragSpeedPercent,
                                                         outputMin: Self.flingSmallPad_000,
                                                         outputMid1: Self.flingSmallPad_025,
                                                         outputMid2: Self.flingSmallPad_050,
                                                         outputMid3: Self.flingSmallPad_075,
                                                         outputMax: Self.flingSmallPad_100)
            }
            
#if FLING_CAPTURE
            let flingMultiplier = testflingMult //Float(0.0) + test01 * 1.2
            MY_MAGIC_EXIFF_DATA = flingMultiplier
#else
            let flingMultiplier = Math.interpolate3(inputMin: Jiggle.minMeasuredSize,
                                                    inputMid: Jiggle.midMeasuredSize,
                                                    inputMax: Jiggle.maxMeasuredSize,
                                                    input: jiggle.measuredSize,
                                                    outputMin: flingMultiplierSmall,
                                                    outputMid: flingMultiplierMedium,
                                                    outputMax: flingMultiplierLarge)
#endif
            
            var magnitude = sqrtf(magnitudeSquared)
            let dirX = powerX / magnitude
            let dirY = powerY / magnitude
            
            let magnitudeCeiling = distanceR2 * 0.66
            if magnitude > magnitudeCeiling {
                magnitude = magnitudeCeiling
            }
            
            
            
            cursorSpeedX = dirX * magnitude * flingMultiplier// * stifle
            cursorSpeedY = dirY * magnitude * flingMultiplier// * stifle
            
        }
    }
    
    func snapTestFling(jiggle: Jiggle,
                       powerX: Float,
                       powerY: Float) {
        
        
        
        let measurePercentLinear = Jiggle.getMeasurePercentLinear(measuredSize: jiggle.measuredSize)
        let distanceR2 = Jiggle.getAnimationCursorFalloffDistance_R2(measurePercentLinear: measurePercentLinear)
        
        let magnitudeSquared = powerX * powerX + powerY * powerY
        if magnitudeSquared > Math.epsilon {
            let magnitude = sqrtf(magnitudeSquared)
            
            let dirX = powerX / magnitude
            let dirY = powerY / magnitude
            
            jiggle.animationCursorX = dirX * distanceR2
            jiggle.animationCursorY = dirY * distanceR2
            
        }
    }
    
    func fling(jiggle: Jiggle,
               releaseAnimusTouches: [AnimusTouch],
               releaseAnimusTouchCount: Int) {
        
        print("Did fling jiggle!!!")
        
        
        var releases = [ReleaseData]()
        for animusTouchIndex in 0..<releaseAnimusTouchCount {
            let animusTouch = releaseAnimusTouches[animusTouchIndex]
            if animusTouch.isExpired == false {
                let release = animusTouch.release()
                if release.isValid {
                    releases.append(release)
                }
            }
        }
        
        //print("Releases: \(releases.count)")
        for release in releases {
            //    print("release: [\(release.dirX), \(release.dirY)], time: \(release.time), magnitude: \(release.magnitude)")
        }
        
        
        var totalTime = Float(0.0)
        for release in releases {
            totalTime += release.time
        }
        if totalTime > Math.epsilon {
            
            var powerX = Float(0.0)
            var powerY = Float(0.0)
            
            var time = Float(0.0)
            for release in releases {
                let timePercent = release.time / totalTime
                powerX += release.dirX * timePercent * release.magnitude
                powerY += release.dirY * timePercent * release.magnitude
            }
            
#if FLING_CAPTURE
            if ApplicationController.shared.flingPlaybackModeWrite {
                ApplicationController.shared.stowFlingData(powerX: powerX, powerY: powerY)
            }
#endif
            
            
            fling(jiggle: jiggle,
                  powerX: powerX,
                  powerY: powerY)
            
            
        }
    }
    
    
    @MainActor func performMemeCommands(jiggle: Jiggle,
                                        jiggleDocument: JiggleDocument,
                                        controller: AnimusController) {
        
        // we do them in order..
        for commandIndex in 0..<memeBag.memeCommandCount {
            let command = memeBag.memeCommands[commandIndex]
            
            pointerBag.sync(jiggle: jiggle,
                            controller: controller,
                            command: command,
                            memeBag: memeBag)
            
            switch command.type {
            case .add:
                captureStart(jiggle: jiggle, jiggleDocument: jiggleDocument,
                             controller: controller,
                             command: command)
            case .remove:
                captureStart(jiggle: jiggle,
                             jiggleDocument: jiggleDocument,
                             controller: controller,
                             command: command)
            case .move:
                captureTrack(jiggle: jiggle,
                             jiggleDocument: jiggleDocument,
                             controller: controller,
                             command: command)
            }
        }
    }
    
    @MainActor func captureStart(jiggle: Jiggle,
                                 jiggleDocument: JiggleDocument,
                                 controller: AnimusController,
                                 command: AnimusTouchMemeCommand) {
        _ = pointerBag.captureStart(jiggle: jiggle)
    }
    
    @MainActor func captureTrack(jiggle: Jiggle,
                                 jiggleDocument: JiggleDocument,
                                 controller: AnimusController,
                                 command: AnimusTouchMemeCommand) {
        _ = pointerBag.captureTrack(jiggle: jiggle,
                                    jiggleDocument: jiggleDocument)
    }
    
}
