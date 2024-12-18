//
//  ApplicationController.swift
//  Jiggle III
//
//  Created by Nicky Taylor on 11/8/23.
//

import Foundation
import Metal

final class ApplicationController {
    
#if FLING_CAPTURE

    static let flingPlaybackSize = 65000
    
    var flingPlaybackModeWrite = false
    private let flingPlaybackFile = FileBuffer()
    var flingPlaybackIndex = 0
    var flingPlaybackDeltaTime = [Float](repeating: 0.0, count: ApplicationController.flingPlaybackSize)
    var flingPlaybackData = [FlingData]()
    var fling_is_binary_search = false
    
    private var flingSaveFilePath: String {
        FileUtils.shared.getDocumentPath(fileName: "ipad_fling_playback.pez")
    }
    private var flingLoadFilePath: String {
        //FileUtils.shared.getMainBundleFilePath(fileName: "ipad_fling_playback.pez")
        FileUtils.shared.getMainBundleFilePath(fileName: "iphone_fling_playback.pez")
    }
    
    var stowedFlingDataX = [Float]()
    var stowedFlingDataY = [Float]()
    
    func stowFlingData(powerX: Float, powerY: Float) {
        stowedFlingDataX.append(powerX)
        stowedFlingDataY.append(powerY)
        print("stowed fling data: \(powerX), \(powerY)")
    }
    
    func flingLoad() {
        if true {
            let fileBuffer = FileBuffer()
            fileBuffer.load(filePath: flingLoadFilePath)
            for index in 0..<ApplicationController.flingPlaybackSize {
                
                let deltaTime = fileBuffer.readFloat32() ?? 0.0
                flingPlaybackDeltaTime[index] = deltaTime
                flingPlaybackData[index].load(fileBuffer: fileBuffer)
                if flingPlaybackData[index].chunks.count > 0 {
                    print("@ \(index), \(flingPlaybackData[index].chunks.count) chunks")
                }
            }
        }
    }
    
    func flingSave() {
        if true {
            let fileBuffer = FileBuffer()
            for index in 0..<ApplicationController.flingPlaybackSize {
                fileBuffer.writeFloat32(flingPlaybackDeltaTime[index])
                flingPlaybackData[index].save(fileBuffer: fileBuffer)
            }
            _ = fileBuffer.save(filePath: flingSaveFilePath)
        }
    }

#endif
    
#if GYRO_CAPTURE
    
    static let gyroPlaybackSize = 25000
    var gyroPlaybackModeWrite = false
    private let gyroPlaybackFile = FileBuffer()
    var gyroPlaybackIndex = 0
    private var gyroPlaybackX = [Float](repeating: 0.0, count: ApplicationController.gyroPlaybackSize)
    private var gyroPlaybackY = [Float](repeating: 0.0, count: ApplicationController.gyroPlaybackSize)
    var gyroPlaybackDeltaTime = [Float](repeating: 0.0, count: ApplicationController.gyroPlaybackSize)
    
    private var gyroSaveFilePath: String {
        FileUtils.shared.getDocumentPath(fileName: "ipad_gyro_playback.zoo")
    }
    private var gyroLoadFilePath: String {
        FileUtils.shared.getMainBundleFilePath(fileName: "ipad_gyro_playback.zoo")
        //FileUtils.shared.getMainBundleFilePath(fileName: "iphone_gyro_playback.zoo")
    }
    
    func gyroLoad() {
        if true {
            let fileBuffer = FileBuffer()
            fileBuffer.load(filePath: gyroLoadFilePath)
            for index in 0..<ApplicationController.gyroPlaybackSize {
                let x = fileBuffer.readFloat32() ?? 0.0
                let y = fileBuffer.readFloat32() ?? 0.0
                let deltaTime = fileBuffer.readFloat32() ?? 0.0
                
                gyroPlaybackX[index] = x
                gyroPlaybackY[index] = y
                gyroPlaybackDeltaTime[index] = deltaTime
            }
        }
    }
    
    func gyroSave() {
        if true {
            let fileBuffer = FileBuffer()
            for index in 0..<ApplicationController.gyroPlaybackSize {
                fileBuffer.writeFloat32(gyroPlaybackX[index])
                fileBuffer.writeFloat32(gyroPlaybackY[index])
                fileBuffer.writeFloat32(gyroPlaybackDeltaTime[index])
                
            }
            _ = fileBuffer.save(filePath: gyroSaveFilePath)
        }
    }
    
#endif
    
    
    // Let's stick with 2048. From the "big" test, numbers up in the 3,000's
    // seem to lag for a realistic large sized jiggle. Lower makes for a
    // more jagged triangulation / outline. This is a good number, forever.
    //
    // An observation, 2048 seems a little too small with ipad;
    //
    static let MAGIC_BIG_SIZE = 2580
    
    static let blankTextIconPack = BlankTextIconPack()
    
    static let FORCE_LONG_ALL = false
    static let FORCE_STACKED_ALL = false
    static let FORCE_1_LINE_ALL = false
    static let FORCE_2_LINE_ALL = false
    
    static let FORCE_CAPS = false
    
    static let DEBUG_DEALLOCS = false
    
    static let TEST_ROW_TOP_1 = true
    static let TEST_ROW_TOP_2 = true
    static let TEST_ROW_TOP_3 = true
    
    static let TEST_ROW_BOTTOM_1 = false
    static let TEST_ROW_BOTTOM_2 = false
    static let TEST_ROW_BOTTOM_3 = false
    static let TEST_ROW_BOTTOM_4 = false
    
    //static let mainRingSelectedLineThickness = Float(Device.isPad ? 2.25 : 1.5)
    //static let mainRingSelectedStrokeThickness = Float(Device.isPad ? 2.75 : 2.0)
    //static let mainRingUnselectedLineThickness = Float(Device.isPad ? 2.0 : 1.25)
    //static let mainRingUnselectedStrokeThickness = Float(Device.isPad ? 2.5 : 1.75)
    
    //@MainActor static let mainRingSelectedLineThickness = Float(Device.isPad ? 1.5 : 1.5 * 0.667)
    //@MainActor static let mainRingSelectedStrokeThickness = Float(Device.isPad ? 2.5 : 2.5 * 0.667)
    //@MainActor static let mainRingUnselectedLineThickness = Float(Device.isPad ? 1.25 : 1.25 * 0.667)
    //@MainActor static let mainRingUnselectedStrokeThickness = Float(Device.isPad ? 2.25 : 2.25 * 0.667)
    
    //static let mainRingSelectedLineThickness = Float(Device.isPad ? 1.5 * 0.8 : 1.5 * 0.667 * 0.8)
    //static let mainRingSelectedStrokeThickness = Float(Device.isPad ? 2.5 * 0.8 : 2.5 * 0.667 * 0.8)
    //static let mainRingUnselectedLineThickness = Float(Device.isPad ? 1.25 * 0.8 : 1.25 * 0.667 * 0.8)
    //static let mainRingUnselectedStrokeThickness = Float(Device.isPad ? 2.25 * 0.8 : 2.25 * 0.667 * 0.8)
    
    weak var jiggleViewModel: JiggleViewModel?
    weak var toolInterfaceViewModel: ToolInterfaceViewModel?
    weak var jiggleViewController: JiggleViewController?
    weak var jiggleDocument: JiggleDocument?
    
    weak var mainMenuViewController: MainMenuViewController?
    
    weak var imageImportViewModel: ImageImportViewModel?
    weak var imageImportViewController: ImageImportViewController?
    
    weak var loadSceneViewModel: LoadSceneViewModel?
    weak var loadSceneViewController: LoadSceneViewController?
    
    
    @MainActor var dialogBoxViews: [DialogBoxView] {
        var result = [DialogBoxView]()
        if let rootViewController = Self.rootViewController {
            if let dialogBoxStackContainerView = rootViewController.dialogBoxStackContainerView {
                for dialogBoxView in dialogBoxStackContainerView.dialogBoxViews {
                    result.append(dialogBoxView)
                }
            }
        }
        return result
    }
    
    func update(deltaTime: Float) {
        
#if GYRO_CAPTURE
        //gyroPlaybackModeWrite
        if gyroPlaybackIndex < Self.gyroPlaybackSize {
            
            if gyroPlaybackModeWrite == true {
                
                gyroPlaybackX[gyroPlaybackIndex] = Self.gyroSmoothX
                gyroPlaybackY[gyroPlaybackIndex] = Self.gyroSmoothY
                gyroPlaybackDeltaTime[gyroPlaybackIndex] = deltaTime
                
                if (gyroPlaybackIndex % 1000) == 0 {
                    print("gyroPlaybackIndex = \(gyroPlaybackIndex) / \(Self.gyroPlaybackSize)")
                }
                
                gyroPlaybackIndex += 1
                if gyroPlaybackIndex == Self.gyroPlaybackSize {
                    print("*** SAVING GYRO HISTORY!!!")
                    gyroSave()
                }
            } else {
                
                if (gyroPlaybackIndex % 2500) == 0 {
                    print("gyroPlaybackIndex = \(gyroPlaybackIndex) / \(Self.gyroPlaybackSize)")
                }
                
                Self.gyroSmoothX = gyroPlaybackX[gyroPlaybackIndex]
                Self.gyroSmoothY = gyroPlaybackY[gyroPlaybackIndex]
                gyroPlaybackIndex += 1
                if gyroPlaybackIndex >= Self.gyroPlaybackSize {
                    print("Gyro LOOPED!!!")

                    if gyroPlaybackIndex == 0 {
                        if let jiggleDocument = jiggleDocument {
                            
                            for jiggleIndex in 0..<jiggleDocument.jiggleCount {
                                let jiggle = jiggleDocument.jiggles[jiggleIndex]
                                jiggle.animationCursorX = 0.0
                                jiggle.animationCursorY = 0.0
                                jiggle.animationCursorScale = 1.0
                                jiggle.animationCursorRotation = 0.0
                                jiggle.animusInstructionGrab.BIGGEST_GYRO = -100.0
                                jiggle.animusInstructionGrab.WW_DA_GYRO_MULT = -100.0
                                jiggle.animusInstructionGrab.sum_speed_1 = Float(0.0)
                                jiggle.animusInstructionGrab.sum_speed_2 = Float(0.0)
                                jiggle.animusInstructionGrab.cursorSpeedX = Float(0.0)
                                jiggle.animusInstructionGrab.cursorSpeedY = Float(0.0)
                                jiggle.animusInstructionGrab.cursorElastic = Float(0.0)
                                
                                Self.gyroSmoothX = 0.0
                                Self.gyroSmoothY = 0.0
                                
                            }
                        }
                    }
                    
                    
                    if let jiggleDocument = jiggleDocument {
                        
                        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
                            let jiggle = jiggleDocument.jiggles[jiggleIndex]
                            
                            let measuredFX = Jiggle.getMeasurePercentLinear(measuredSize: jiggle.measuredSize)
                            
                            let BIGGEST_GYRO = jiggle.animusInstructionGrab.BIGGEST_GYRO
                            let WW_DA_GYRO_MULT = jiggle.animusInstructionGrab.WW_DA_GYRO_MULT
                            let radius2 = Jiggle.getAnimationCursorFalloffDistance_R2(measuredSize: jiggle.measuredSize)
                            let radius3 = Jiggle.getAnimationCursorFalloffDistance_R3(measuredSize: jiggle.measuredSize)
                            let targetRadius = radius2 + (radius3 - radius2) * 0.60
                            
                            let sum_speed_1 = jiggle.animusInstructionGrab.sum_speed_1
                            let sum_speed_2 = jiggle.animusInstructionGrab.sum_speed_2
                            
                            print("[EOT] Jiggle, BIGGEST_GYRO = \(BIGGEST_GYRO) targetRadius = \(targetRadius)")
                            print("[EOT] Jiggle, WW_DA_GYRO_MULT = \(WW_DA_GYRO_MULT)")
                            print("[EOT] Jiggle Measure percent = \(measuredFX), measuredSize = \(jiggle.measuredSize)")
                            
                            print("[EOT] Jiggle Measure sum_speed_1 = \(sum_speed_1), sum_speed_2 = \(sum_speed_2)")
                            
                            jiggle.animationCursorX = 0.0
                            jiggle.animationCursorY = 0.0
                            jiggle.animationCursorScale = 1.0
                            jiggle.animationCursorRotation = 0.0
                            jiggle.animusInstructionGrab.BIGGEST_GYRO = -100.0
                            jiggle.animusInstructionGrab.WW_DA_GYRO_MULT = -100.0
                            jiggle.animusInstructionGrab.sum_speed_1 = Float(0.0)
                            jiggle.animusInstructionGrab.sum_speed_2 = Float(0.0)
                            jiggle.animusInstructionGrab.cursorSpeedX = Float(0.0)
                            jiggle.animusInstructionGrab.cursorSpeedY = Float(0.0)
                            jiggle.animusInstructionGrab.cursorElastic = Float(0.0)
                            
                            print("ok, done")
                            
                            Self.gyroSmoothX = 0.0
                            Self.gyroSmoothY = 0.0
                            
                        }
                    }
                }
            }
        }
#endif
        
#if FLING_CAPTURE
        //flingPlaybackModeWrite
        if flingPlaybackIndex < Self.flingPlaybackSize {
            
            if flingPlaybackModeWrite == true {
                
                flingPlaybackDeltaTime[flingPlaybackIndex] = deltaTime
                
                if stowedFlingDataX.count > 0 {
                    
                    for stowIndex in 0..<stowedFlingDataX.count {
                        let powerX = stowedFlingDataX[stowIndex]
                        let powerY = stowedFlingDataY[stowIndex]
                        let chunqqqkkk = FlingData.FlingChunk(powerX: powerX, powerY: powerY)
                        flingPlaybackData[flingPlaybackIndex].chunks.append(chunqqqkkk)
                    }
                    
                    stowedFlingDataX.removeAll()
                    stowedFlingDataY.removeAll()
                }
                
                
                if (flingPlaybackIndex % 2500) == 0 {
                    print("flingPlaybackIndex = \(flingPlaybackIndex) / \(Self.flingPlaybackSize)")
                }
                
                flingPlaybackIndex += 1
                if flingPlaybackIndex == Self.flingPlaybackSize {
                    print("*** SAVING FLING HISTORY!!!")
                    flingSave()
                }
            } else {
                
                if ApplicationController.shared.fling_is_binary_search == false {
                    if (flingPlaybackIndex % 5000) == 0 {
                        print("flingPlaybackIndex = \(flingPlaybackIndex) / \(Self.flingPlaybackSize)")
                    }
                }
                
                for chunk in flingPlaybackData[flingPlaybackIndex].chunks {
                    if let jiggleDocument = jiggleDocument {
                        
                        for jiggleIndex in 0..<jiggleDocument.jiggleCount {
                            let jiggle = jiggleDocument.jiggles[jiggleIndex]
                            
                            jiggle.animusInstructionGrab.snapTestFling(jiggle: jiggle,
                                                                       powerX: chunk.powerX,
                                                                       powerY: chunk.powerY)
                            
                            jiggle.animusInstructionGrab.fling(jiggle: jiggle,
                                                               powerX: chunk.powerX,
                                                               powerY: chunk.powerY)
                        }
                    }
                }
                
                flingPlaybackIndex += 1
                
                
                if flingPlaybackIndex >= Self.flingPlaybackSize {
                    print("Fling LOOPED!!!")
                    
                    if flingPlaybackIndex == 0 {
                        if let jiggleDocument = jiggleDocument {
                            for jiggleIndex in 0..<jiggleDocument.jiggleCount {
                                let jiggle = jiggleDocument.jiggles[jiggleIndex]
                                jiggle.animationCursorX = 0.0
                                jiggle.animationCursorY = 0.0
                                jiggle.animationCursorScale = 1.0
                                jiggle.animationCursorRotation = 0.0
                                jiggle.animusInstructionGrab.sum_speed_1 = Float(0.0)
                                jiggle.animusInstructionGrab.sum_speed_2 = Float(0.0)
                                jiggle.animusInstructionGrab.cursorSpeedX = Float(0.0)
                                jiggle.animusInstructionGrab.cursorSpeedY = Float(0.0)
                                jiggle.animusInstructionGrab.cursorElastic = Float(0.0)
                                jiggle.animusInstructionGrab.MY_MAGIC_EXIFF_DATA = Float(0.0)
                                
                            }
                        }
                    }
                    
                    if flingPlaybackIndex >= Self.flingPlaybackSize {
                        if let jiggleDocument = jiggleDocument {
                            for jiggleIndex in 0..<jiggleDocument.jiggleCount {
                                let jiggle = jiggleDocument.jiggles[jiggleIndex]
                                
                                let measuredFX = Jiggle.getMeasurePercentLinear(measuredSize: jiggle.measuredSize)
                                let radius3 = Jiggle.getAnimationCursorFalloffDistance_R3(measuredSize: jiggle.measuredSize)
                                let radius2 = Jiggle.getAnimationCursorFalloffDistance_R2(measuredSize: jiggle.measuredSize)
                                let targetRadius = radius3 * 1.122
                                
                                let BIGGEST_FLING = jiggle.animusInstructionGrab.BIGGEST_FLING
                                let BIGGEST_POWER = jiggle.animusInstructionGrab.BIGGEST_POWER
                                let MY_MAGIC_EXIFF_DATA = jiggle.animusInstructionGrab.MY_MAGIC_EXIFF_DATA
                                
                                let sum_speed_1 = jiggle.animusInstructionGrab.sum_speed_1
                                let sum_speed_2 = jiggle.animusInstructionGrab.sum_speed_2
                                
                                print("[EOT] Jiggle, BIGGEST_FLING = \(BIGGEST_FLING) targetRadius = \(targetRadius)")
                                print("[EOT] Jiggle, MY_MAGIC_EXIFF_DATA = \(MY_MAGIC_EXIFF_DATA) targetRadius = \(targetRadius)")
                                
                                if ApplicationController.shared.fling_is_binary_search == false {
                                    jiggle.animationCursorX = 0.0
                                    jiggle.animationCursorY = 0.0
                                    jiggle.animationCursorScale = 1.0
                                    jiggle.animationCursorRotation = 0.0
                                    jiggle.animusInstructionGrab.BIGGEST_FLING = -100.0
                                    jiggle.animusInstructionGrab.BIGGEST_POWER = -100.0
                                    jiggle.animusInstructionGrab.sum_speed_1 = Float(0.0)
                                    jiggle.animusInstructionGrab.sum_speed_2 = Float(0.0)
                                    jiggle.animusInstructionGrab.cursorSpeedX = Float(0.0)
                                    jiggle.animusInstructionGrab.cursorSpeedY = Float(0.0)
                                    jiggle.animusInstructionGrab.cursorElastic = Float(0.0)
                                    jiggle.animusInstructionGrab.MY_MAGIC_EXIFF_DATA = Float(0.0)
                                }
                            }
                        }
                    }
                    
                    
                }
            }
        }
#endif
        
        
    }
    
    
    //nonisolated(unsafe)
    //@MainActor
    //nonisolated(unsafe)
    nonisolated(unsafe) static let shared = ApplicationController()
    
    //@MainActor
    private init() {
        
        configLoad()
        ToolInterfaceElementTable.build()
        
        
        
    }
    
    //@MainActor
    nonisolated(unsafe) static var isDarkModeEnabled = false
    nonisolated(unsafe) static var isPurchased = false
    
    nonisolated(unsafe) static var isGlowingSelectionEnabled = false
    nonisolated(unsafe) static var isGuideInsetMarkersEnabled = true
    nonisolated(unsafe) static var isGuideInsetMarkersDenseEnabled = true
    
    nonisolated(unsafe) static var isPreciseJoyPadEnabled = true
    
    nonisolated(unsafe) static var preciseScaleAmount = JiggleViewModel.preciseScaleAmountUserDefault
    
    static let userJiggleOpacityMin = Float(0.0)
    static let userJiggleOpacityMax = Float(100.0)
    nonisolated(unsafe) static var userJiggleOpacity = Float(60.0)
    
    static let userInsetMarkersPowerMin = Float(0.0)
    static let userInsetMarkersPowerMax = Float(100.0)
    static let userInsetMarkersPowerDefault = Float(40.0)
    
    //nonisolated(unsafe) static var userInsetMarkersPower = Float(50.0)
    
    static let amountInsetMarkersPowerMin = Float(2.0)
    static let amountInsetMarkersPowerMax = Float(24.0)
    
    static let userLineThicknessMin = Float(0.0)
    static let userLineThicknessMax = Float(100.0)
    nonisolated(unsafe) static var userLineThickness = Float(50.0)
    
    static let amountLineThicknessFillUnselectedMin = Float(0.6)
    static let amountLineThicknessFillUnselectedMax = amountLineThicknessFillUnselectedMin + 0.8
    static let amountLineThicknessFillSelectedMin = Float(0.8)
    static let amountLineThicknessFillSelectedMax = amountLineThicknessFillSelectedMin + 0.8
    static let amountLineThicknessFillFrozenMin = Float(0.6)
    static let amountLineThicknessFillFrozenMax = amountLineThicknessFillFrozenMin + 0.8
    
    static let amountLineThicknessStrokeUnselectedMin = amountLineThicknessFillUnselectedMin + 0.6
    static let amountLineThicknessStrokeUnselectedMax = amountLineThicknessFillUnselectedMax + 1.2
    static let amountLineThicknessStrokeSelectedMin = amountLineThicknessFillSelectedMin + 0.6
    static let amountLineThicknessStrokeSelectedMax = amountLineThicknessFillSelectedMax + 1.2
    static let amountLineThicknessStrokeFrozenMin = amountLineThicknessFillFrozenMin + 0.6
    static let amountLineThicknessStrokeFrozenMax = amountLineThicknessFillFrozenMax + 1.2
    
    static func getAmountLineThicknessFill(lineThicknessType: LineThicknessType) -> Float {
        let numer = (ApplicationController.userLineThickness - ApplicationController.userLineThicknessMin)
        let denom = (ApplicationController.userLineThicknessMax - ApplicationController.userLineThicknessMin)
        var lineThicknessPercent = numer / denom
        if lineThicknessPercent < 0.0 { lineThicknessPercent = 0.0 }
        if lineThicknessPercent > 1.0 { lineThicknessPercent = 1.0 }
        return getAmountLineThicknessFill(lineThicknessType: lineThicknessType, percent: lineThicknessPercent)
    }
    
    static func getAmountLineThicknessStroke(lineThicknessType: LineThicknessType) -> Float {
        let numer = (ApplicationController.userLineThickness - ApplicationController.userLineThicknessMin)
        let denom = (ApplicationController.userLineThicknessMax - ApplicationController.userLineThicknessMin)
        var lineThicknessPercent = numer / denom
        if lineThicknessPercent < 0.0 { lineThicknessPercent = 0.0 }
        if lineThicknessPercent > 1.0 { lineThicknessPercent = 1.0 }
        return getAmountLineThicknessStroke(lineThicknessType: lineThicknessType, percent: lineThicknessPercent)
    }
    
    static func getAmountLineThicknessFill(lineThicknessType: LineThicknessType, percent: Float) -> Float {
        switch lineThicknessType {
        case .frozen:
            return amountLineThicknessFillFrozenMin + (amountLineThicknessFillFrozenMax - amountLineThicknessFillFrozenMin) * percent
        case .unselected:
            return amountLineThicknessFillUnselectedMin + (amountLineThicknessFillUnselectedMax - amountLineThicknessFillUnselectedMin) * percent
        case .selected:
            return amountLineThicknessFillSelectedMin + (amountLineThicknessFillSelectedMax - amountLineThicknessFillSelectedMin) * percent
        }
    }
    
    static func getAmountLineThicknessStroke(lineThicknessType: LineThicknessType, percent: Float) -> Float {
        switch lineThicknessType {
        case .frozen:
            return amountLineThicknessStrokeFrozenMin + (amountLineThicknessStrokeFrozenMax - amountLineThicknessStrokeFrozenMin) * percent
        case .unselected:
            return amountLineThicknessStrokeUnselectedMin + (amountLineThicknessStrokeUnselectedMax - amountLineThicknessStrokeUnselectedMin) * percent
        case .selected:
            return amountLineThicknessStrokeSelectedMin + (amountLineThicknessStrokeSelectedMax - amountLineThicknessStrokeSelectedMin) * percent
        }
    }
    
    static let insetMarkerPointCountMin = 1
    static let insetMarkerPointCountMax = 8
    static let insetMarkerPointCountDefault = 3
    nonisolated(unsafe) static var insetMarkerPointCount = insetMarkerPointCountDefault
    
    static let userPointSizeMin = Float(0.0)
    static let userPointSizeMax = Float(100.0)
    nonisolated(unsafe) static var userPointSize = Float(50.0)
    static let amountPointSizeMin = Float(0.0)
    static let amountPointSizeMax = Float(100.0)
    
    //@MainActor
    @MainActor static var rootViewModel: RootViewModel?
    @MainActor static var rootViewController: RootViewController?
    @MainActor static let device = Device()
    
    nonisolated(unsafe) static var accelerometerX = Float(0.0)
    nonisolated(unsafe) static var accelerometerY = Float(0.0)
    nonisolated(unsafe) static var accelerometerZ = Float(0.0)
    
    nonisolated(unsafe) static var gyroDirectionX = Float(0.0)
    nonisolated(unsafe) static var gyroDirectionY = Float(0.0)
    
    func wake() {
        
#if GYRO_CAPTURE
        if gyroPlaybackModeWrite == false {
            gyroLoad()
        }
#endif
        
#if FLING_CAPTURE
        while flingPlaybackData.count < ApplicationController.flingPlaybackSize {
            let data = FlingData()
            flingPlaybackData.append(data)
        }
        
        if flingPlaybackModeWrite == false {
            flingLoad()
        }
#endif
        
    }
    
    static let gyroHistorySize: Int = 12
    nonisolated(unsafe) static var gyroHistoryJerkX = [Float](repeating: 0.0, count: gyroHistorySize)
    nonisolated(unsafe) static var gyroHistoryJerkY = [Float](repeating: 0.0, count: gyroHistorySize)
    nonisolated(unsafe) static var gyroHistoryFactor: [Float] = [0.026, 0.029, 0.035, // 0.09
                                             0.042, 0.0430, 0.065, // 0.15
                                             0.075, 0.085, 0.10, // 0.26
                                             0.135, 0.165, 0.2] // 0.5
    nonisolated(unsafe) static var gyroSmoothX = Float(0.0)
    nonisolated(unsafe) static var gyroSmoothY = Float(0.0)
    
    
    static func recordGyroDirectionHistory(jerkX: Float, jerkY: Float) {
        //
        for historyIndex in 1..<gyroHistorySize {
            gyroHistoryJerkX[historyIndex - 1] = gyroHistoryJerkX[historyIndex]
            gyroHistoryJerkY[historyIndex - 1] = gyroHistoryJerkY[historyIndex]
        }
        //
        gyroHistoryJerkX[gyroHistorySize - 1] = -jerkX
        gyroHistoryJerkY[gyroHistorySize - 1] = -jerkY
        //
        
        var _gyroSmoothX = Float(0.0)
        var _gyroSmoothY = Float(0.0)
        for historyIndex in 0..<gyroHistorySize {
            let factor = gyroHistoryFactor[historyIndex]
            _gyroSmoothX += gyroHistoryJerkX[historyIndex] * factor
            _gyroSmoothY += gyroHistoryJerkY[historyIndex] * factor
        }
        
#if GYRO_CAPTURE
        if ApplicationController.shared.gyroPlaybackModeWrite == true {
            Self.gyroSmoothX = _gyroSmoothX
            Self.gyroSmoothY = _gyroSmoothY
        }
#else
        Self.gyroSmoothX = _gyroSmoothX
        Self.gyroSmoothY = _gyroSmoothY
#endif
        
    }
    
    private var configFilePath: String {
        FileUtils.shared.getDocumentPath(fileName: "config.cgf")
    }
    
    func configLoad() {
        let fileBuffer = FileBuffer()
        fileBuffer.load(filePath: configFilePath)
        configLoad(fileBuffer: fileBuffer)
    }
    
    func configSave() {
        let fileBuffer = FileBuffer()
        configSave(fileBuffer: fileBuffer)
        _ = fileBuffer.save(filePath: configFilePath)
    }
    
    func configLoad(fileBuffer: FileBuffer) {
        
        Self.isDarkModeEnabled = fileBuffer.readBool() ?? false
        Self.isPurchased = fileBuffer.readBool() ?? false
        Self.isGlowingSelectionEnabled = fileBuffer.readBool() ?? false
        Self.isGuideInsetMarkersEnabled = fileBuffer.readBool() ?? false
        Self.isGuideInsetMarkersDenseEnabled = fileBuffer.readBool() ?? false
        Self.isPreciseJoyPadEnabled = fileBuffer.readBool() ?? false
        
        Self.userJiggleOpacity = fileBuffer.readFloat32() ?? Float(60.0)
        Self.userLineThickness = fileBuffer.readFloat32() ?? Float(60.0)
        Self.userPointSize = fileBuffer.readFloat32() ?? Float(60.0)
        
        if let value = fileBuffer.readInt32() {
            ApplicationController.insetMarkerPointCount = Int(value)
            if ApplicationController.insetMarkerPointCount > ApplicationController.insetMarkerPointCountMax {
                ApplicationController.insetMarkerPointCount = ApplicationController.insetMarkerPointCountMax
            }
            if ApplicationController.insetMarkerPointCount < ApplicationController.insetMarkerPointCountMin {
                ApplicationController.insetMarkerPointCount = ApplicationController.insetMarkerPointCountMin
            }
        }
    }
    
    func configSave(fileBuffer: FileBuffer) {
        
        fileBuffer.writeBool(Self.isDarkModeEnabled)
        fileBuffer.writeBool(Self.isPurchased)
        fileBuffer.writeBool(Self.isGlowingSelectionEnabled)
        fileBuffer.writeBool(Self.isGuideInsetMarkersEnabled)
        fileBuffer.writeBool(Self.isGuideInsetMarkersDenseEnabled)
        fileBuffer.writeBool(Self.isPreciseJoyPadEnabled)
        
        fileBuffer.writeFloat32(Float(Self.userJiggleOpacity))
        fileBuffer.writeFloat32(Float(Self.userLineThickness))
        fileBuffer.writeFloat32(Float(Self.userPointSize))
        
        fileBuffer.writeInt32(Int32(ApplicationController.insetMarkerPointCount))
    }
    
}
