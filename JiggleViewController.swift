//
//  JiggleViewController.swift
//  Jiggle3
//
//  Created by Nicky Taylor on 11/9/23.
//

import UIKit

class JiggleViewController: MetalViewController {
    
    func dispose() {
        jiggleViewModel.dispose()
        toolInterfaceViewModel.dispose()
        if Device.isPad {
            padDraggableMenu.dispose()
        } else {
            phoneTopMenu.dispose()
            phoneBottomMenu.dispose()
        }
    }
    
    
    static let expandButtonWidth: CGFloat = 48.0
    static let expandButtonHeight: CGFloat = 44.0
    
    weak var jiggleContainerViewController: JiggleContainerViewController?
    
    var isMenuExpandCollapseAnimating = false
    
    var isStereoscopicEnabledTick = 0
    
    static func getDisplayAnimationTime() -> CGFloat {
        
        /*
        if Device.isPad {
            return 0.72
        } else {
            return 0.62
        }
        */
        
        if Device.isPad {
            return 0.62
        } else {
            return 0.54
        }
    }
    
    static func getRowsAnimationTime(orientation: Orientation) -> CGFloat {
        if Device.isPad {
            return 0.56
        } else {
            switch orientation {
            case .landscape:
                return 0.56
            case .portrait:
                return 0.36
            }
        }
    }
    
    static func getExpandCollapseAnimationTime(orientation: Orientation) -> CGFloat {
        switch orientation {
        case .landscape:
            return 0.34
        case .portrait:
            return 0.36
        }
    }
    
    static let phoneMenuCollapseOffset = 8
    
    var toolAction: ToolAction?
    
    lazy var historyController: HistoryController = {
        HistoryController(jiggleViewController: self)
    }()
    
    lazy var padDraggableMenuLeftConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: padDraggableMenu,
                                  attribute: .left, relatedBy: .equal,
                                  toItem: view, attribute: .left,
                                  multiplier: 1.0, constant: 0.0)
    }()
    
    lazy var phoneExpandToolbarButtonTop: ExpandToolbarButton = {
        let result = ExpandToolbarButton(isAtTopOfScreen: true)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.addTarget(self, action: #selector(clickExpandTop), for: .touchUpInside)
        return result
    }()
    
    lazy var phoneExpandToolbarButtonTopLeftConstraint: NSLayoutConstraint = {
        return phoneExpandToolbarButtonTop.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4096.0)
    }()
    
    lazy var phoneExpandToolbarButtonTopTopConstraint: NSLayoutConstraint = {
        return phoneExpandToolbarButtonTop.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0)
    }()
    
    lazy var phoneExpandToolbarButtonBottom: ExpandToolbarButton = {
        let result = ExpandToolbarButton(isAtTopOfScreen: false)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.addTarget(self, action: #selector(clickExpandBottom), for: .touchUpInside)
        return result
    }()
    
    lazy var phoneExpandToolbarButtonBottomBottomConstraint: NSLayoutConstraint = {
        return phoneExpandToolbarButtonBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0)
    }()
    
    lazy var phoneExpandToolbarButtonBottomLeftConstraint: NSLayoutConstraint = {
        return phoneExpandToolbarButtonBottom.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0.0)
    }()
    
    lazy var padDraggableMenuTopConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: padDraggableMenu,
                                  attribute: .top, relatedBy: .equal,
                                  toItem: view, attribute: .top,
                                  multiplier: 1.0, constant: 0.0)
    }()
    
    lazy var padDraggableMenuWidthConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: padDraggableMenu,
                                  attribute: .width, relatedBy: .equal,
                                  toItem: nil, attribute: .notAnAttribute,
                                  multiplier: 1.0, constant: 520.0)
    }()
    
    lazy var padDraggableMenuHeightConstraint: NSLayoutConstraint = {
        return NSLayoutConstraint(item: padDraggableMenu,
                                  attribute: .height, relatedBy: .equal,
                                  toItem: nil, attribute: .notAnAttribute,
                                  multiplier: 1.0, constant: 512.0)
    }()
    
    var tabletSaveMenuTick = 0
    
    var dragTabletInterfaceMenuTouch: UITouch?
    var dragTabletInterfaceMenuStartX = CGFloat(0.0)
    var dragTabletInterfaceMenuStartY = CGFloat(0.0)
    var dragTabletInterfaceMenuStartTouchX = CGFloat(0.0)
    var dragTabletInterfaceMenuStartTouchY = CGFloat(0.0)
    
    enum MenuCorner {
        case topLeft
        case topRight
        case bottomLeft
        case bottomRight
    }
    
    var resizeTabletInterfaceMenuTouch: UITouch?
    var resizeTabletInterfaceMenuStartX = CGFloat(0.0)
    var resizeTabletInterfaceMenuStartWidth = CGFloat(0.0)
    var resizeTabletInterfaceMenuStartTouchX = CGFloat(0.0)
    var resizeTabletInterfaceMenuCorner = MenuCorner.topLeft
    
    lazy var padDraggableMenu: DraggableMenuView = {
        let result = DraggableMenuView(toolInterfaceViewModel: jiggleViewModel.toolInterfaceViewModel)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.standardContainerView.graphContainerView.graphView.jiggleScene = jiggleScene
        result.standardContainerView.graphContainerView.graphView.jiggleDocument = jiggleDocument
        result.standardContainerView.timeLineContainerView.timeLineView.jiggleScene = jiggleScene
        result.standardContainerView.timeLineContainerView.timeLineView.jiggleDocument = jiggleDocument
        result.standardContainerView.timeLineContainerView.timeLineView.jiggleViewModel = jiggleViewModel
        return result
    }()
    
    lazy var phoneTopMenuPositionConstraint: NSLayoutConstraint = {
        NSLayoutConstraint(item: phoneTopMenu, attribute: .bottom, relatedBy: .equal,
                           toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0.0)
    }()
    
    lazy var phoneTopMenu: TopMenuView = {
        let result = TopMenuView(toolInterfaceViewModel: jiggleViewModel.toolInterfaceViewModel)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.standardContainerView.graphContainerView.graphView.jiggleScene = jiggleScene
        result.standardContainerView.graphContainerView.graphView.jiggleDocument = jiggleDocument
        result.standardContainerView.timeLineContainerView.timeLineView.jiggleScene = jiggleScene
        result.standardContainerView.timeLineContainerView.timeLineView.jiggleDocument = jiggleDocument
        result.standardContainerView.timeLineContainerView.timeLineView.jiggleViewModel = jiggleViewModel
        return result
    }()
    
    lazy var phoneBottomMenu: BottomMenuView = {
        let result = BottomMenuView(toolInterfaceViewModel: jiggleViewModel.toolInterfaceViewModel)
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    lazy var phoneBottomMenuPositionConstraint: NSLayoutConstraint = {
        NSLayoutConstraint(item: phoneBottomMenu, attribute: .top, relatedBy: .equal,
                           toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0)
    }()
    
    let jiggleViewModel: JiggleViewModel
    let jiggleScene: JiggleScene
    let jiggleEngine: JiggleEngine
    let jiggleDocument: JiggleDocument
    var toolInterfaceViewModel: ToolInterfaceViewModel { jiggleViewModel.toolInterfaceViewModel }
    
    lazy var gestureView: GestureView = {
        let result = GestureView(frame: CGRect(x: 0.0, y: 0.0, width: 512.0, height: 512.0))
        result.translatesAutoresizingMaskIntoConstraints = false
        return result
    }()
    
    required init(jiggleViewModel: JiggleViewModel,
                  jiggleScene: JiggleScene,
                  jiggleDocument: JiggleDocument) {
        self.jiggleViewModel = jiggleViewModel
        self.jiggleScene = jiggleScene
        self.jiggleEngine = jiggleScene.jiggleEngine
        self.jiggleDocument = jiggleDocument
        
        super.init(delegate: jiggleScene,
                   width: jiggleScene.width,
                   height: jiggleScene.height)
        
        ApplicationController.shared.jiggleViewController = self
        
        jiggleViewModel.gestureView = self.gestureView
        jiggleScene.jiggleViewModel = jiggleViewModel
        jiggleEngine.jiggleViewModel = jiggleViewModel
        
        jiggleViewModel.jiggleViewController = self
        jiggleViewModel.toolInterfaceViewModel.jiggleViewController = self
        jiggleViewModel.publisherLinkUp()
    }
    
    deinit {
        if ApplicationController.DEBUG_DEALLOCS {
            print("[--] JiggleViewController")
        }
    }
    
    required init(delegate: GraphicsDelegate, width: Float, height: Float) {
        fatalError("init(delegate:width:height:name:) has not been implemented")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        postUpdateInterfaceWidth()
    }
    
    func handleSafeAreaDidChange(safeAreaLeft: Int, safeAreaRight: Int, safeAreaTop: Int, safeAreaBottom: Int) {
        registerContentFrame(safeAreaLeft: safeAreaLeft,
                             safeAreaRight: safeAreaRight,
                             safeAreaTop: safeAreaTop,
                             safeAreaBottom: safeAreaBottom)
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }
    
    override func update(deltaTime: Float, stereoSpreadBase: Float, stereoSpreadMax: Float) {
        
        //modeTestViewController.update()
        
        phoneExpandToolbarButtonTop.update(deltaTime: deltaTime)
        phoneExpandToolbarButtonBottom.update(deltaTime: deltaTime)
        
        if jiggleViewModel.jiggleScene.isDisplayTransitionActiveSwivel {
            isStereoscopicEnabled = false
            isStereoscopicEnabledTick = 2
        } else {
            if jiggleViewModel.isStereoscopicEnabled {
                switch jiggleDocument.documentMode {
                case .view:
                    
                    if isStereoscopicEnabledTick > 0 {
                        isStereoscopicEnabledTick -= 1
                        isStereoscopicEnabled = false
                    } else {
                        isStereoscopicEnabledTick = 0
                        isStereoscopicEnabled = true
                    }
                case .edit:
                    isStereoscopicEnabled = false
                    isStereoscopicEnabledTick = 2
                }
            } else {
                isStereoscopicEnabled = false
                isStereoscopicEnabledTick = 2
            }
        }
        
        toolActionStep()
        
        
        
        //TODO: Uncommeng
        //gestureView.update(deltaTime: deltaTime)
        //jiggleViewModel.update(deltaTime: deltaTime)
        //
        
        
        
        // Junk Below
        
#if GYRO_CAPTURE
        
        
        if ApplicationController.shared.gyroPlaybackModeWrite {
            
            gestureView.update(deltaTime: deltaTime)
            jiggleViewModel.update(deltaTime: deltaTime)
            super.update(deltaTime: deltaTime, stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
            
            ApplicationController.shared.update(deltaTime: deltaTime)
            
        } else {
            
            
            let LOOPZ = 100_000_000
            //let LOOPZ = 1
            
            if ApplicationController.shared.gyroPlaybackIndex < ApplicationController.gyroPlaybackSize {
                
                for _ in 0..<LOOPZ {
                    if ApplicationController.shared.gyroPlaybackIndex < ApplicationController.gyroPlaybackSize {
                        
                        let _deltaTime = ApplicationController.shared.gyroPlaybackDeltaTime[ApplicationController.shared.gyroPlaybackIndex]
                        
                        gestureView.update(deltaTime: deltaTime)
                        jiggleViewModel.update(deltaTime: deltaTime)
                        super.update(deltaTime: deltaTime, stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
                        
                        //TODO: Temp
                        ApplicationController.shared.update(deltaTime: _deltaTime)
                        
                    }
                }
            } else {
                
                gestureView.update(deltaTime: deltaTime)
                jiggleViewModel.update(deltaTime: deltaTime)
                super.update(deltaTime: deltaTime, stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
                
            }
        }
        
#elseif FLING_CAPTURE
        
        if ApplicationController.shared.flingPlaybackModeWrite {
            
            gestureView.update(deltaTime: deltaTime)
            jiggleViewModel.update(deltaTime: deltaTime)
            super.update(deltaTime: deltaTime, stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
            
            ApplicationController.shared.update(deltaTime: deltaTime)
            
        } else {
            
            
            if ApplicationController.shared.fling_is_binary_search {
                
                var jiggleee: Jiggle?
                if jiggleDocument.jiggleCount > 0 {
                    jiggleee = jiggleDocument.jiggles[0]
                }
                
                if let jiggle = jiggleee {
                    
                    jiggle.animusInstructionGrab.BIGGEST_GYRO = 0.0
                    
                    let radius3 = Jiggle.getAnimationCursorFalloffDistance_R3(measuredSize: jiggle.measuredSize)
                    let radius2 = Jiggle.getAnimationCursorFalloffDistance_R2(measuredSize: jiggle.measuredSize)
                    let targetRadius = radius3 * 1.122
                    
                    
                    var low = Float(0.0)
                    var high = Float(4.0)
                    
                    for bs_index in 0..<32 {
                        
                        var mid = (low + high) / 2.0
                        
                        jiggle.animusInstructionGrab.testflingMult = mid
                        jiggle.animusInstructionGrab.BIGGEST_FLING = 0.0
                        
                        ApplicationController.shared.flingPlaybackIndex = 0
                        let LOOPZ = 100_000_000
                        
                        for _ in 0..<LOOPZ {
                            if ApplicationController.shared.flingPlaybackIndex < ApplicationController.flingPlaybackSize {
                                
                                let _deltaTime = ApplicationController.shared.flingPlaybackDeltaTime[ApplicationController.shared.flingPlaybackIndex]
                                
                                gestureView.update(deltaTime: deltaTime)
                                jiggleViewModel.update(deltaTime: deltaTime)
                                super.update(deltaTime: deltaTime, stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
                                
                                //TODO: Temp
                                ApplicationController.shared.update(deltaTime: _deltaTime)
                            } else {
                                break
                            }
                        }
                        
                        let BIGGEST_FLING = jiggle.animusInstructionGrab.BIGGEST_FLING
                        
                        if BIGGEST_FLING > targetRadius {
                            high = mid
                        } else {
                            low = mid
                        }
                        
                        
                        print("BS loop @\(bs_index), number was \(BIGGEST_FLING) [\(low) <= \(mid) <= \(high)]")
                    }
                    
                    
                    
                }
                
                
                ApplicationController.shared.fling_is_binary_search = false
            } else {
                
                
                
                let LOOPZ = 100_000_000
                //let LOOPZ = 40
                
                //let LOOPZ = 1
                
                if ApplicationController.shared.flingPlaybackIndex < ApplicationController.flingPlaybackSize {
                    
                    for _ in 0..<LOOPZ {
                        if ApplicationController.shared.flingPlaybackIndex < ApplicationController.flingPlaybackSize {
                            
                            let _deltaTime = ApplicationController.shared.flingPlaybackDeltaTime[ApplicationController.shared.flingPlaybackIndex]
                            
                            gestureView.update(deltaTime: deltaTime)
                            jiggleViewModel.update(deltaTime: deltaTime)
                            super.update(deltaTime: deltaTime, stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
                            
                            //TODO: Temp
                            ApplicationController.shared.update(deltaTime: _deltaTime)
                        } else {
                            break
                        }
                    }
                    
                } else {
                    
                    gestureView.update(deltaTime: deltaTime)
                    jiggleViewModel.update(deltaTime: deltaTime)
                    super.update(deltaTime: deltaTime, stereoSpreadBase: stereoSpreadBase, stereoSpreadMax: stereoSpreadMax)
                    
                }
                
            }
            
            
            
            
        }
        
#else
        gestureView.update(deltaTime: deltaTime)
        jiggleViewModel.update(deltaTime: deltaTime)
        
        
#endif
        
        // Junk Above
        
        if Device.isPad {
            tabletSaveMenuTick += 1
            if tabletSaveMenuTick >= 100 {
                tabletSaveMenuTick = 0
                menuSave()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gestureView.delegate = self
        
        let orientation = jiggleDocument.orientation
        
        if let view = view {
            view.addSubview(gestureView)
            view.addConstraints([
                gestureView.leftAnchor.constraint(equalTo: view.leftAnchor),
                gestureView.rightAnchor.constraint(equalTo: view.rightAnchor),
                gestureView.topAnchor.constraint(equalTo: view.topAnchor),
                gestureView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }
        
        let appWidth: Int
        //let appHeight: Int
        switch orientation {
        case .landscape:
            appWidth = Int(Device.widthLandscape + 0.5)
            //appHeight = Int(Device.heightLandscape + 0.5)
        case .portrait:
            appWidth = Int(Device.widthPortrait + 0.5)
            //appHeight = Int(Device.heightPortrait + 0.5)
        }
        
        let safeAreaLeft: Int
        let safeAreaRight: Int
        let safeAreaTop: Int
        let safeAreaBottom: Int
        if let rootViewController = ApplicationController.rootViewController {
            safeAreaLeft = Int(rootViewController.view.safeAreaInsets.left + 0.5)
            safeAreaRight = Int(rootViewController.view.safeAreaInsets.right + 0.5)
            safeAreaTop = Int(rootViewController.view.safeAreaInsets.top + 0.5)
            safeAreaBottom = Int(rootViewController.view.safeAreaInsets.bottom + 0.5)
        } else {
            safeAreaLeft = 0
            safeAreaRight = 0
            safeAreaTop = 0
            safeAreaBottom = 0
        }
        
        if Device.isPad {
            
            if let view = view {
                
                let width = 520
                let rowHeight = ToolInterfaceTheme.getRowHeight(orientation: jiggleDocument.orientation)
                let interfaceConfiguration = jiggleViewModel.toolInterfaceViewModel.getCurrentInterfaceConfigurationPad()
                let height = MenuHeightCategoryPad.get(configuration: interfaceConfiguration, orientation: orientation)
                
                view.addSubview(padDraggableMenu)
                
                padDraggableMenuWidthConstraint.constant = CGFloat(width)
                padDraggableMenuHeightConstraint.constant = CGFloat(height)
                
                padDraggableMenu.addConstraints([padDraggableMenuWidthConstraint,
                                                 padDraggableMenuHeightConstraint])
                
                view.addConstraints([padDraggableMenuLeftConstraint,
                                     padDraggableMenuTopConstraint])
                
                padDraggableMenuLeftConstraint.constant = 120.0
                padDraggableMenuTopConstraint.constant = 120.0
                
                padDraggableMenu.setup(width: width,
                                       height: height,
                                       orientation: orientation)
                
                jiggleViewModel.toolInterfaceViewModel.layoutAllRowsTablet(menuWidthWithSafeArea: width,
                                                                           rowHeight:  rowHeight,
                                                                           safeAreaLeft: 0,
                                                                           safeAreaRight: 0)
            }
        } else {
            
            if let view = view {
                
                let width: Int
                switch orientation {
                case .landscape:
                    width = Int(Device.widthLandscape + 0.5)
                case .portrait:
                    width = Int(Device.widthPortrait + 0.5)
                }
                
                view.addSubview(phoneTopMenu)
                view.addSubview(phoneBottomMenu)
                
                phoneTopMenu.addConstraint(NSLayoutConstraint(item: phoneTopMenu, attribute: .height, relatedBy: .equal,
                                                              toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 512.0))
                phoneBottomMenu.addConstraint(NSLayoutConstraint(item: phoneBottomMenu, attribute: .height, relatedBy: .equal,
                                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 512.0))
                
                view.addConstraints([
                    phoneTopMenu.leftAnchor.constraint(equalTo: view.leftAnchor),
                    phoneTopMenu.rightAnchor.constraint(equalTo: view.rightAnchor),
                    phoneTopMenuPositionConstraint
                ])
                
                view.addConstraints([
                    phoneBottomMenu.leftAnchor.constraint(equalTo: view.leftAnchor),
                    phoneBottomMenu.rightAnchor.constraint(equalTo: view.rightAnchor),
                    phoneBottomMenuPositionConstraint
                ])
                
                
                
                phoneTopMenu.setup(width: width,
                                   safeAreaLeft: safeAreaLeft, safeAreaRight: safeAreaRight,
                                   safeAreaTop: safeAreaTop)
                
                phoneBottomMenu.setup(width: width,
                                      safeAreaLeft: safeAreaLeft, safeAreaRight: safeAreaRight,
                                      safeAreaBottom: safeAreaBottom)
                
            }
            postUpdateInterfaceWidth()
        }
        
        if Device.isPhone {
            
            phoneExpandToolbarButtonBottom.masterBoundsWidth = CGFloat(appWidth)
            phoneExpandToolbarButtonBottom.masterSafeAreaLeft = CGFloat(safeAreaLeft)
            phoneExpandToolbarButtonBottom.masterSafeAreaRight = CGFloat(safeAreaRight)
            
            phoneExpandToolbarButtonTop.masterBoundsWidth = CGFloat(appWidth)
            phoneExpandToolbarButtonTop.masterSafeAreaLeft = CGFloat(safeAreaLeft)
            phoneExpandToolbarButtonTop.masterSafeAreaRight = CGFloat(safeAreaRight)
            
            phoneExpandToolbarButtonBottom.leftConstraint = phoneExpandToolbarButtonBottomLeftConstraint
            phoneExpandToolbarButtonBottomLeftConstraint.constant = CGFloat(safeAreaLeft)
            view.addSubview(phoneExpandToolbarButtonBottom)
            phoneExpandToolbarButtonBottom.addConstraints([
                NSLayoutConstraint(item: phoneExpandToolbarButtonBottom, attribute: .width, relatedBy: .equal, toItem: nil,
                                   attribute: .notAnAttribute, multiplier: 1.0, constant: Self.expandButtonWidth),
                NSLayoutConstraint(item: phoneExpandToolbarButtonBottom, attribute: .height, relatedBy: .equal, toItem: nil,
                                   attribute: .notAnAttribute, multiplier: 1.0, constant: Self.expandButtonHeight),
            ])
            
            view.addConstraints([phoneExpandToolbarButtonBottomBottomConstraint,
                                 phoneExpandToolbarButtonBottomLeftConstraint])
            
            phoneExpandToolbarButtonTop.leftConstraint = phoneExpandToolbarButtonTopLeftConstraint
            phoneExpandToolbarButtonTopLeftConstraint.constant = CGFloat(safeAreaLeft)
            view.addSubview(phoneExpandToolbarButtonTop)
            phoneExpandToolbarButtonTop.addConstraints([
                NSLayoutConstraint(item: phoneExpandToolbarButtonTop, attribute: .width, relatedBy: .equal, toItem: nil,
                                   attribute: .notAnAttribute, multiplier: 1.0, constant: Self.expandButtonWidth),
                NSLayoutConstraint(item: phoneExpandToolbarButtonTop, attribute: .height, relatedBy: .equal, toItem: nil,
                                   attribute: .notAnAttribute, multiplier: 1.0, constant: Self.expandButtonHeight),
            ])
            
            view.addConstraints([phoneExpandToolbarButtonTopTopConstraint,
                                 phoneExpandToolbarButtonTopLeftConstraint])
            
            phoneExpandToolbarButtonBottomBottomConstraint.constant = CGFloat(-safeAreaBottom) - 4.0
            phoneExpandToolbarButtonTopTopConstraint.constant = CGFloat(safeAreaTop) + 4.0
            
        }
        
        if Device.isPad {
            
            //TODO: This is for testing... IDK, we want this?
            menuLoad()
        }
        
        //
        // Verified that this is needed on iPhone, but not iPad.
        // I am leaving it universally for symmetry.
        //
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        if Device.isPhone {
            phoneTopMenu.setNeedsLayout()
            phoneTopMenu.layoutIfNeeded()
            phoneTopMenu.refreshShadowDisplay()
            phoneTopMenu.refreshGraphDisplay()
            phoneTopMenu.refreshTimeLineDisplay()
            
            phoneBottomMenu.setNeedsLayout()
            phoneBottomMenu.layoutIfNeeded()
            phoneBottomMenu.refreshShadowDisplay()
            
        } else {
            padDraggableMenu.setNeedsLayout()
            padDraggableMenu.layoutIfNeeded()
        }
        
        registerContentFrame(safeAreaLeft: safeAreaLeft,
                             safeAreaRight: safeAreaRight,
                             safeAreaTop: safeAreaTop,
                             safeAreaBottom: safeAreaBottom)
        
    }
    
    func registerContentFrame(safeAreaLeft: Int, safeAreaRight: Int, safeAreaTop: Int, safeAreaBottom: Int) {
        let orientation = jiggleDocument.orientation
        let appWidth: Int
        let appHeight: Int
        switch orientation {
        case .landscape:
            appWidth = Int(Device.widthLandscape + 0.5)
            appHeight = Int(Device.heightLandscape + 0.5)
        case .portrait:
            appWidth = Int(Device.widthPortrait + 0.5)
            appHeight = Int(Device.heightPortrait + 0.5)
        }
        
        if Device.isPhone {
            var interfaceConfiguration = toolInterfaceViewModel.getCurrentInterfaceConfigurationPhone()
            interfaceConfiguration.prepare(disableCreatorModes: false)
            let topMenuHeight = MenuHeightCategoryPhoneTop.get(category: interfaceConfiguration.heightCategoryTop,
                                                               orientation: orientation)
            let bottomMenuHeight = MenuHeightCategoryPhoneBottom.get(category: interfaceConfiguration.heightCategoryBottom,
                                                                     orientation: orientation)
            
            snapMenuExpandedPhone(configuration: interfaceConfiguration,
                                  snapMenus: true)
            
            jiggleScene.registerContentFrame(clipFrameX: 0, clipFrameY: 0,
                                             clipFrameWidth: Float(appWidth), clipFrameHeight: Float(appHeight),
                                             safeAreaLeft: safeAreaLeft, safeAreaRight: safeAreaRight,
                                             safeAreaTop: safeAreaTop, safeAreaBottom: safeAreaBottom,
                                             topMenuHeight: topMenuHeight, isTopMenuExpanded: interfaceConfiguration.isExpandedTop,
                                             bottomMenuHeight: bottomMenuHeight, isBottomMenuExpanded: interfaceConfiguration.isExpandedBottom)
            
            phoneTopMenu.handleSafeArea(width: appWidth,
                                        safeAreaLeft: safeAreaLeft, safeAreaRight: safeAreaRight,
                                        safeAreaTop: safeAreaTop)
            
            phoneBottomMenu.handleSafeArea(width: appWidth,
                                           safeAreaLeft: safeAreaLeft, safeAreaRight: safeAreaRight,
                                           safeAreaBottom: safeAreaBottom)
            
            let blockerHeight = ToolInterfaceTheme.getTopBlockerHeight(orientation: orientation,
                                                                       safeAreaTop: safeAreaTop)
            
            phoneTopMenu.standardContainerView.graphContainerView.dragBlockerViewHeightConstraint.constant = CGFloat(blockerHeight)
            phoneTopMenu.standardContainerView.graphContainerView.setNeedsLayout()
            phoneTopMenu.standardContainerView.timeLineContainerView.dragBlockerViewHeightConstraint.constant = CGFloat(blockerHeight)
            phoneTopMenu.standardContainerView.timeLineContainerView.setNeedsLayout()
            
            phoneTopMenu.standardContainerView.timeLineContainerView.handleBlockerHeightOrSafeAreaDidChange(blockerHeight: blockerHeight,
                                                                                                            safeAreaTop: safeAreaTop,
                                                                                                            orientation: orientation)
            
            phoneTopMenu.standardContainerView.setNeedsLayout()
            phoneTopMenu.setNeedsLayout()
            phoneTopMenu.layoutIfNeeded()
            
            
            phoneExpandToolbarButtonBottom.masterBoundsWidth = CGFloat(appWidth)
            phoneExpandToolbarButtonBottom.masterSafeAreaLeft = CGFloat(safeAreaLeft)
            phoneExpandToolbarButtonBottom.masterSafeAreaRight = CGFloat(safeAreaRight)
            
            phoneExpandToolbarButtonTop.masterBoundsWidth = CGFloat(appWidth)
            phoneExpandToolbarButtonTop.masterSafeAreaLeft = CGFloat(safeAreaLeft)
            phoneExpandToolbarButtonTop.masterSafeAreaRight = CGFloat(safeAreaRight)
            
            phoneExpandToolbarButtonBottomBottomConstraint.constant = CGFloat(-safeAreaBottom) - 4.0
            phoneExpandToolbarButtonTopTopConstraint.constant = CGFloat(safeAreaTop) + 4.0
            
            let safeLeft = CGFloat(safeAreaLeft)
            let safeRight = CGFloat(appWidth) - CGFloat(safeAreaRight) - CGFloat(Self.expandButtonWidth)
            
            if phoneExpandToolbarButtonTopLeftConstraint.constant < safeLeft {
                phoneExpandToolbarButtonTopLeftConstraint.constant = safeLeft
            }
            
            if (phoneExpandToolbarButtonTopLeftConstraint.constant) > safeRight {
                phoneExpandToolbarButtonTopLeftConstraint.constant = safeRight
            }
            
            if phoneExpandToolbarButtonBottomLeftConstraint.constant < safeLeft {
                phoneExpandToolbarButtonBottomLeftConstraint.constant = safeLeft
            }
            
            if (phoneExpandToolbarButtonBottomLeftConstraint.constant) > safeRight {
                phoneExpandToolbarButtonBottomLeftConstraint.constant = safeRight
            }
            
        } else {
            var interfaceConfiguration = toolInterfaceViewModel.getCurrentInterfaceConfigurationPad()
            interfaceConfiguration.prepare(disableCreatorModes: false)
            snapMenuExpandedPad(configuration: interfaceConfiguration,
                                snapMenus: true)
            jiggleScene.registerContentFrame(clipFrameX: 0, clipFrameY: 0,
                                             clipFrameWidth: Float(appWidth), clipFrameHeight: Float(appHeight),
                                             safeAreaLeft: safeAreaLeft, safeAreaRight: safeAreaRight,
                                             safeAreaTop: safeAreaTop, safeAreaBottom: safeAreaBottom,
                                             topMenuHeight: 0, isTopMenuExpanded: false,
                                             bottomMenuHeight: 0, isBottomMenuExpanded: false)
        }
        
        registerGraphFrame()
        registerTimeLineFrame()
        
    }
    
    func registerGraphFrame() {
        let orientation = jiggleDocument.orientation
        
        let rowHeight = ToolInterfaceTheme.getRowHeight(orientation: orientation)
        
        var graphWidth: Int
        var graphHeight: Int
        if Device.isPhone {
            
            let safeAreaLeft: Int
            let safeAreaRight: Int
            let safeAreaTop: Int
            if let rootViewController = ApplicationController.rootViewController {
                safeAreaLeft = Int(rootViewController.view.safeAreaInsets.left + 0.5)
                safeAreaRight = Int(rootViewController.view.safeAreaInsets.right + 0.5)
                safeAreaTop = Int(rootViewController.view.safeAreaInsets.top + 0.5)
            } else {
                safeAreaLeft = 0
                safeAreaRight = 0
                safeAreaTop = 0
            }
            
            switch orientation {
            case .landscape:
                graphWidth = Int(Device.widthLandscape + 0.5)
            case .portrait:
                graphWidth = Int(Device.widthPortrait + 0.5)
            }
            
            let graphRowCount = ToolInterfaceTheme.getTopMenuGraphRowCount(orientation: orientation)
            
            let rowSeparatorHeight = ToolInterfaceTheme.getStationaryRowSeparatorHeight(orientation: orientation)
            
            graphHeight = (graphRowCount * rowHeight)
            if graphRowCount > 1 {
                graphHeight += ((graphRowCount - 1) * rowSeparatorHeight)
            }
            
            graphWidth -= safeAreaLeft
            graphWidth -= ToolInterfaceTheme.getTopGraphInsetLeft(orientation: orientation)
            graphWidth -= ToolInterfaceTheme.getTopGraphInsetRight(orientation: orientation)
            graphWidth -= safeAreaRight
            
            graphHeight -= ToolInterfaceTheme.getTopGraphInsetTop(orientation: orientation)
            graphHeight -= ToolInterfaceTheme.getTopGraphInsetBottom(orientation: orientation)
            graphHeight -= ToolInterfaceTheme.getTopBlockerHeight(orientation: orientation,
                                                                  safeAreaTop: safeAreaTop)
            
        } else {
            graphWidth = Int(padDraggableMenu.bounds.size.width + 0.5)
            
            let graphRowCount = ToolInterfaceTheme.getDraggableMenuStandardTopHalfRowCount()
            let rowSeparatorHeight = ToolInterfaceTheme.getDraggableMenuRowSeparatorHeight()
            graphHeight = (graphRowCount * rowHeight)
            if graphRowCount > 1 {
                graphHeight += ((graphRowCount - 1) * rowSeparatorHeight)
            }
            
            graphWidth -= ToolInterfaceTheme.getDraggableMenuGraphInsetLeft()
            graphWidth -= ToolInterfaceTheme.getDraggableMenuGraphInsetRight()
            graphHeight -= ToolInterfaceTheme.getDraggableMenuGraphInsetTop()
            graphHeight -= ToolInterfaceTheme.getDraggableMenuGraphInsetBottom()
        }
        
        jiggleScene.graphWidth = Float(graphWidth)
        jiggleScene.graphHeight = Float(graphHeight)
        
        if Device.isPhone {
            phoneTopMenu.standardContainerView.refreshGraphDisplay()
        } else {
            padDraggableMenu.standardContainerView.refreshGraphDisplay()
            
        }
    }
    
    func registerTimeLineFrame() {
        let orientation = jiggleDocument.orientation
        
        let rowHeight = ToolInterfaceTheme.getRowHeight(orientation: orientation)
        
        var timeLineWidth: Int
        var timeLineHeight: Int
        if Device.isPhone {
            
            let safeAreaLeft: Int
            let safeAreaRight: Int
            let safeAreaTop: Int
            if let rootViewController = ApplicationController.rootViewController {
                safeAreaLeft = Int(rootViewController.view.safeAreaInsets.left + 0.5)
                safeAreaRight = Int(rootViewController.view.safeAreaInsets.right + 0.5)
                safeAreaTop = Int(rootViewController.view.safeAreaInsets.top + 0.5)
            } else {
                safeAreaLeft = 0
                safeAreaRight = 0
                safeAreaTop = 0
            }
            
            switch orientation {
            case .landscape:
                timeLineWidth = Int(Device.widthLandscape + 0.5)
            case .portrait:
                timeLineWidth = Int(Device.widthPortrait + 0.5)
            }
            
            let timeLineRowCount = ToolInterfaceTheme.getTopMenuTimeLineRowCount(orientation: orientation)
            
            let rowSeparatorHeight = ToolInterfaceTheme.getStationaryRowSeparatorHeight(orientation: orientation)
            
            timeLineHeight = (timeLineRowCount * rowHeight)
            if timeLineRowCount > 1 {
                timeLineHeight += ((timeLineRowCount - 1) * rowSeparatorHeight)
            }
            
            timeLineWidth -= safeAreaLeft
            timeLineWidth -= ToolInterfaceTheme.getTopTimeLineInsetLeft(orientation: orientation)
            timeLineWidth -= ToolInterfaceTheme.getTopTimeLineInsetRight(orientation: orientation)
            timeLineWidth -= safeAreaRight
            
            timeLineHeight -= ToolInterfaceTheme.getTopTimeLineInsetTop(orientation: orientation)
            timeLineHeight -= ToolInterfaceTheme.getTopTimeLineInsetBottom(orientation: orientation)
            timeLineHeight -= ToolInterfaceTheme.getTopBlockerHeight(orientation: orientation,
                                                                     safeAreaTop: safeAreaTop)
            
        } else {
            timeLineWidth = Int(padDraggableMenu.bounds.size.width + 0.5)
            
            let timeLineRowCount = ToolInterfaceTheme.getDraggableMenuStandardTopHalfRowCount()
            let rowSeparatorHeight = ToolInterfaceTheme.getDraggableMenuRowSeparatorHeight()
            timeLineHeight = (timeLineRowCount * rowHeight)
            if timeLineRowCount > 1 {
                timeLineHeight += ((timeLineRowCount - 1) * rowSeparatorHeight)
            }
            
            timeLineWidth -= ToolInterfaceTheme.getDraggableMenuTimeLineInsetLeft()
            timeLineWidth -= ToolInterfaceTheme.getDraggableMenuTimeLineInsetRight()
            timeLineHeight -= ToolInterfaceTheme.getDraggableMenuTimeLineInsetTop()
            timeLineHeight -= ToolInterfaceTheme.getDraggableMenuTimeLineInsetBottom()
        }
        
        jiggleScene.timeLineWidth = Float(timeLineWidth)
        jiggleScene.timeLineHeight = Float(timeLineHeight)
        
        if jiggleViewModel.jiggleDocument.isTimeLineMode {
            jiggleViewModel.timeLineUpdateRelay()
        }
        
        refreshTimeLineDisplay()
    }
    
    func refreshTimeLineDisplay() {
        if Device.isPhone {
            phoneTopMenu.standardContainerView.refreshTimeLineDisplay()
        } else {
            padDraggableMenu.standardContainerView.refreshTimeLineDisplay()
        }
    }
    
    @objc func sliderValueDidChange(sender: UISlider) {
        postUpdateInterfaceWidth()
    }
    
    func postUpdateInterfaceWidth() {
        if !Device.isPad {
            let rowHeight = ToolInterfaceTheme.getRowHeight(orientation: jiggleDocument.orientation)
            
            let safeAreaLeft: Int
            let safeAreaRight: Int
            if let rootViewController = ApplicationController.rootViewController {
                safeAreaLeft = Int(rootViewController.view.safeAreaInsets.left + 0.5)
                safeAreaRight = Int(rootViewController.view.safeAreaInsets.right + 0.5)
            } else {
                safeAreaLeft = 0
                safeAreaRight = 0
            }
            
            let width: Int
            switch jiggleDocument.orientation {
            case .landscape:
                width = Int(Device.widthLandscape + 0.5)
            case .portrait:
                width = Int(Device.widthPortrait + 0.5)
            }

            jiggleViewModel.toolInterfaceViewModel.layoutAllRowsPhone(menuWidthWithSafeArea: width,
                                                                      rowHeight: rowHeight,
                                                                      safeAreaLeft: safeAreaLeft,
                                                                      safeAreaRight: safeAreaRight)
            
        }
    }
    
    func set(documentMode: DocumentMode) {
        if toolInterfaceViewModel.isBlocked { return }
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.documentMode = documentMode
            return [ToolActionPhaseSliceSetDocumentMode(documentMode: documentMode)]
        }, alongsideMeshCommand: {
            [ ]
        })
        toolActionPerform(toolAction)
    }
    
    func set(editMode: EditMode) {
        if toolInterfaceViewModel.isBlocked { return }
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.editMode = editMode
            return [ToolActionPhaseSliceSetEditMode(editMode: editMode)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func set(weightMode: WeightMode) {
        if toolInterfaceViewModel.isBlocked { return }
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.weightMode = weightMode
            return [ToolActionPhaseSliceSetWeightMode(weightMode: weightMode)]
        }, alongsideMeshCommand: {
            [ ]
        })
        toolActionPerform(toolAction)
    }
    
    func set(pointSelectionMode: PointSelectionModality) {
        if toolInterfaceViewModel.isBlocked { return }
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            return [ToolActionPhaseSliceSetPointSelectionMode(pointSelectionModality: pointSelectionMode)]
        }, alongsideMeshCommand: {
            [ ]
        })
        toolActionPerform(toolAction)
    }
    
    func batchInterfaceAction(disableCreatorModes: Bool,
                              changeCommand: (inout any InterfaceConfigurationConforming) -> [ToolActionPhaseSlice],
                              alongsideMeshCommand: () -> [ToolActionPhaseSlice]) -> ToolAction {
        
        // 1.) The configurations.
        var interfaceConfigurationPrevious = toolInterfaceViewModel.getCurrentInterfaceConfiguration()
        var interfaceConfigurationCurrent = interfaceConfigurationPrevious
        
        
        // 2.) The mofifications to current.
        let changeCommandSlices = changeCommand(&interfaceConfigurationCurrent)
        let alongsideMeshCommandSlices = alongsideMeshCommand()
        // 3.) Prepare the configurations.
        interfaceConfigurationPrevious.prepare(disableCreatorModes: false)
        interfaceConfigurationCurrent.prepare(disableCreatorModes: disableCreatorModes)
        
        let phaseSliceInterfaceUpdate = getInterfaceConfigurationUpdateSlice(
            previous: interfaceConfigurationPrevious,
            current: interfaceConfigurationCurrent)
        
        var previousExpanded1 = false
        var previousExpanded2 = false
        var currentExpanded1 = false
        var currentExpanded2 = false
        if Device.isPad {
            if let interfaceConfigurationPrevious = interfaceConfigurationPrevious as? InterfaceConfigurationPad,
               let interfaceConfigurationCurrent = interfaceConfigurationCurrent as? InterfaceConfigurationPad{
                previousExpanded1 = interfaceConfigurationPrevious.isExpanded
                currentExpanded1 = interfaceConfigurationCurrent.isExpanded
                previousExpanded2 = interfaceConfigurationPrevious.isExpanded
                currentExpanded2 = interfaceConfigurationCurrent.isExpanded
            }
        } else {
            if let interfaceConfigurationPrevious = interfaceConfigurationPrevious as? InterfaceConfigurationPhone,
               let interfaceConfigurationCurrent = interfaceConfigurationCurrent as? InterfaceConfigurationPhone{
                previousExpanded1 = interfaceConfigurationPrevious.isExpandedTop
                currentExpanded1 = interfaceConfigurationCurrent.isExpandedTop
                previousExpanded2 = interfaceConfigurationPrevious.isExpandedBottom
                currentExpanded2 = interfaceConfigurationCurrent.isExpandedBottom
            }
        }
        
        let interfaceTime = InterfaceConfigurationPhone.getAnimationTime(previousConfiguration: interfaceConfigurationPrevious,
                                                                         previousExpanded1: previousExpanded1,
                                                                         previousExpanded2: previousExpanded2,
                                                                         currentConfiguration: interfaceConfigurationCurrent,
                                                                         currentExpanded1: currentExpanded1,
                                                                         currentExpanded2: currentExpanded2,
                                                                         orientation: jiggleDocument.orientation)
        
        let phaseSliceRenderingModeTransition = InterfaceConfigurationPhone.getPhaseSliceSetRenderingDisplayModesTransition(
            previousConfiguration: interfaceConfigurationPrevious,
            currentConfiguration: interfaceConfigurationCurrent)
        let phaseSliceRenderingModeComplete = InterfaceConfigurationPhone.getPhaseSliceSetRenderingDisplayModesTransitionComplete(
            currentConfiguration: interfaceConfigurationCurrent)
        
        let phaseSlicePreciseModesTransition = InterfaceConfigurationPhone.getPhaseSliceSetRenderingPreciseModesTransition(
            previousConfiguration: interfaceConfigurationPrevious,
            currentConfiguration: interfaceConfigurationCurrent)
        let phaseSlicePreciseModesComplete = InterfaceConfigurationPhone.getPhaseSliceSetRenderingPreciseModesTransitionComplete(
            currentConfiguration: interfaceConfigurationCurrent)
        
        
        let phaseSliceInterfacePrepare = getInterfaceConfigurationPrepareSlice(
            previous: interfaceConfigurationPrevious,
            current: interfaceConfigurationCurrent)
        
        var phases = [ToolActionPhase]()
        
        if InterfaceConfigurationPhone.getMeshCommandRequired(previousConfiguration: interfaceConfigurationPrevious,
                                                              currentConfiguration: interfaceConfigurationCurrent,
                                                              disableCreatorModes: disableCreatorModes) {
            
            var phaseChangeCommandSlices = [ToolActionPhaseSlice]()
            phaseChangeCommandSlices.append(ToolActionPhaseSliceLockState())
            if disableCreatorModes {
                phaseChangeCommandSlices.append(ToolActionPhaseSliceDisableAllCreateModes())
            }
            phaseChangeCommandSlices.append(contentsOf: changeCommandSlices)
            phaseChangeCommandSlices.append(phaseSliceInterfacePrepare)
            let phaseChangeCommand = ToolActionPhase(slices: phaseChangeCommandSlices)
            phases.append(phaseChangeCommand)
            
            let meshCommand = InterfaceConfigurationPhone.getMeshCommand(previous: interfaceConfigurationPrevious,
                                                                         current: interfaceConfigurationCurrent)
            
            //print("meshCommand = \(meshCommand)")
            
            let guideCommand = GuideCommand.none
            let phaseSliceMeshCommand = ToolActionPhaseSliceJiggleMeshCommandAllJiggles(meshCommand: meshCommand, guideCommand: guideCommand)
            
            //alongsideMeshCommand
            var phaseMeshSlices = [ToolActionPhaseSlice]()
            phaseMeshSlices.append(phaseSliceMeshCommand)
            phaseMeshSlices.append(contentsOf: alongsideMeshCommandSlices)
            
            let phaseMesh = ToolActionPhase(slices: phaseMeshSlices)
            phases.append(phaseMesh)
            
            let phaseInterfaceUpdate = ToolActionPhase(slices: [phaseSliceInterfaceUpdate,
                                                                phaseSliceRenderingModeTransition,
                                                                phaseSlicePreciseModesTransition,
                                                                ToolActionPhaseSliceUnlockState()],
                                                       time: interfaceTime)
            phaseInterfaceUpdate.blockers.append(.animateMenuConfigurationRows)
            phaseInterfaceUpdate.blockers.append(.animateMenuConfigurationGraphOrTimeline)
            phaseInterfaceUpdate.blockers.append(.animateMenuExpandOrCollapse)
            phaseInterfaceUpdate.blockers.append(.animateDisplayTransition)
            phases.append(phaseInterfaceUpdate)
            
            let phaseRenderingModeComplete = ToolActionPhase(slices: [phaseSliceRenderingModeComplete,
                                                                      phaseSlicePreciseModesComplete])
            phases.append(phaseRenderingModeComplete)
            
        } else {
            
            var phaseChangeCommandSlices = [ToolActionPhaseSlice]()
            if disableCreatorModes {
                phaseChangeCommandSlices.append(ToolActionPhaseSliceDisableAllCreateModes())
            }
            phaseChangeCommandSlices.append(contentsOf: changeCommandSlices)
            phaseChangeCommandSlices.append(phaseSliceInterfacePrepare)
            let phaseChangeCommand = ToolActionPhase(slices: phaseChangeCommandSlices)
            phases.append(phaseChangeCommand)
            
            let phaseInterfaceUpdate = ToolActionPhase(slices: [phaseSliceInterfaceUpdate,
                                                                phaseSliceRenderingModeTransition,
                                                                phaseSlicePreciseModesTransition],
                                                       time: interfaceTime)
            phaseInterfaceUpdate.blockers.append(.animateMenuConfigurationRows)
            phaseInterfaceUpdate.blockers.append(.animateMenuConfigurationGraphOrTimeline)
            phaseInterfaceUpdate.blockers.append(.animateMenuExpandOrCollapse)
            phaseInterfaceUpdate.blockers.append(.animateDisplayTransition)
            phases.append(phaseInterfaceUpdate)
            
            let phaseRenderingModeComplete = ToolActionPhase(slices: [phaseSliceRenderingModeComplete,
                                                                      phaseSlicePreciseModesComplete])
            phases.append(phaseRenderingModeComplete)
            
        }
        
        let result = ToolAction(phases: phases)
        return result
    }
    
    func setCreatorModeUpdatingMesh(_ creatorMode: CreatorMode) {
        
        if jiggleDocument.creatorMode == creatorMode { return }
        if toolInterfaceViewModel.isBlocked { return }
        
        var phases = [ToolActionPhase]()
        
        let phaseLockState = ToolActionPhase(slice: ToolActionPhaseSliceLockState())
        phases.append(phaseLockState)
        
        let phaseSliceCreatorMode = ToolActionPhaseSliceSetCreatorMode(creatorMode: creatorMode)
        
        let meshType = JiggleMeshCommand.getMeshTypeIfNeeded(documentMode: jiggleDocument.documentMode,
                                                             isGuidesEnabled: jiggleDocument.isGuidesEnabled)
        let swivelType = JiggleMeshCommand.getSwivelTypeIfNeeded(documentMode: jiggleDocument.documentMode,
                                                                 displayMode: jiggleViewModel.displayMode,
                                                                 isGuidesEnabled: jiggleDocument.isGuidesEnabled,
                                                                 isGraphEnabled: jiggleViewModel.isGraphEnabled)
        let weightCurveType = JiggleMeshCommand.getWeightCurveTypeIfNeeded(documentMode: jiggleDocument.documentMode,
                                                                           isGuidesEnabled: jiggleDocument.isGuidesEnabled,
                                                                           isGraphEnabled: jiggleViewModel.isGraphEnabled)
        let meshCommand = JiggleMeshCommand(spline: false,
                                            triangulationType: .beautiful,
                                            meshType: meshType,
                                            outlineType: .ifNeeded,
                                            swivelType: swivelType,
                                            weightCurveType: weightCurveType)
        let guideCommand = GuideCommand.none
        let phaseSliceMeshCommand = ToolActionPhaseSliceJiggleMeshCommandAllJiggles(meshCommand: meshCommand, guideCommand: guideCommand)
        let phaseMesh = ToolActionPhase(slices: [phaseSliceCreatorMode, phaseSliceMeshCommand])
        phases.append(phaseMesh)
        
        let phaseUnlockState = ToolActionPhase(slice: ToolActionPhaseSliceUnlockState())
        phases.append(phaseUnlockState)
        
        let toolAction = ToolAction(phases: phases)
        toolActionPerform(toolAction)
    }
    
    override func drawloop() {
        super.drawloop()
    }
    
    @objc func clickExpandTop() {
        jiggleViewModel.toolInterfaceViewModel.toolActionPhoneToggleTopMenu()
    }
    
    @objc func clickExpandBottom() {
        jiggleViewModel.toolInterfaceViewModel.toolActionPhoneToggleBottomMenu()
    }
    
    func graphToggle() {
        if jiggleViewModel.isGraphEnabled == false {
            graphEnter()
        } else {
            graphExit()
        }
    }
    
    func graphEnter() {
        if jiggleDocument.getSelectedJiggle() !== nil {
            graphGo(isEnabled: true)
        }
    }
    
    func graphExit() {
        graphGo(isEnabled: false)
    }
    
    func graphGo(isEnabled: Bool) {
        
        if jiggleViewModel.isGraphEnabled == isEnabled { return }
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.isGraphEnabled = isEnabled
            return [ToolActionPhaseSliceSetGraphMode(isGraphMode: isEnabled)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func guidesEnter() {
        guidesGo(isEnabled: true)
    }
    
    func guidesExit() {
        guidesGo(isEnabled: false)
    }
    
    func guidesGo(isEnabled: Bool) {
        
        if jiggleViewModel.jiggleDocument.isGuidesEnabled == isEnabled {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.isGuidesEnabled = isEnabled
            return [ ToolActionPhaseSliceSetGuidesMode(isGuideMode: isEnabled) ]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func zoomEnter() {
        zoomGo(isEnabled: true)
    }
    
    func zoomExit() {
        zoomGo(isEnabled: false)
    }
    
    func zoomGo(isEnabled: Bool) {
        
        if jiggleViewModel.isZoomEnabled == isEnabled {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: false,
                                              changeCommand: { configuration in
            configuration.isZoomEnabled = isEnabled
            return [ToolActionPhaseSliceSetZoomMode(isZoomMode: isEnabled)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    
    
    func stereoscopicEnter() {
        stereoscopicGo(isEnabled: true)
    }
    
    func stereoscopicExit() {
        stereoscopicGo(isEnabled: false)
    }
    
    func stereoscopicGo(isEnabled: Bool) {
        
        if jiggleViewModel.isStereoscopicEnabled == isEnabled {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            return [ToolActionPhaseSliceSetStereoscopicMode(isStereoscopicMode: isEnabled)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    
    func timeLineSwatchGo(swatch: Swatch) {
        
        jiggleViewModel.selectedTimeLineSwatch = swatch
        if let selectedJiggle = jiggleDocument.getSelectedJiggle() {
            timeLineUpdateRelay(jiggle: selectedJiggle)
        }
        toolInterfaceViewModel.handleSelectedTimeLineSwatchDidChange()
        jiggleViewModel.killDragAll(killDragReleaseSource: .internalCancelAction)
        
        /*
         if jiggleViewModel.selectedTimeLineSwatch == swatch {
         return
         }
         
         if toolInterfaceViewModel.isBlocked { return }
         
         let toolAction = batchInterfaceAction(disableCreatorModes: true,
         changeCommand: { configuration in
         configuration.selectedTimeLineSwatch = swatch
         return [ToolActionPhaseSliceSetTimeLineSwatch(swatch: swatch)]
         }, alongsideMeshCommand: {
         [ ]
         })
         
         toolActionPerform(toolAction)
         */
    }
    
    // All the modifications to "current" must already be done... Such as "is graph enabled..."...
    func getInterfaceConfigurationUpdateSlice(previous: (any InterfaceConfigurationConforming),
                                              current: (any InterfaceConfigurationConforming)) -> ToolActionPhaseSlice {
        if Device.isPad {
            let previous = (previous as? InterfaceConfigurationPad) ?? InterfaceConfigurationPad()
            let current = (current as? InterfaceConfigurationPad) ?? InterfaceConfigurationPad()
            return ToolActionPhaseSliceUpdateInterfaceConfigurationPad(interfaceConfigurationPrevious: previous,
                                                                       interfaceConfigurationCurrent: current)
        } else {
            let previous = (previous as? InterfaceConfigurationPhone) ?? InterfaceConfigurationPhone()
            let current = (current as? InterfaceConfigurationPhone) ?? InterfaceConfigurationPhone()
            return ToolActionPhaseSliceUpdateInterfaceConfigurationPhone(interfaceConfigurationPrevious: previous,
                                                                         interfaceConfigurationCurrent: current)
        }
    }
    
    // All the modifications to "current" must already be done... Such as "is graph enabled..."...
    func getInterfaceConfigurationPrepareSlice(previous: (any InterfaceConfigurationConforming),
                                               current: (any InterfaceConfigurationConforming)) -> ToolActionPhaseSlice {
        if Device.isPad {
            let previous = (previous as? InterfaceConfigurationPad) ?? InterfaceConfigurationPad()
            let current = (current as? InterfaceConfigurationPad) ?? InterfaceConfigurationPad()
            return ToolActionPhaseSlicePrepareInterfaceConfigurationPad(interfaceConfigurationPrevious: previous,
                                                                        interfaceConfigurationCurrent: current)
        } else {
            let previous = (previous as? InterfaceConfigurationPhone) ?? InterfaceConfigurationPhone()
            let current = (current as? InterfaceConfigurationPhone) ?? InterfaceConfigurationPhone()
            return ToolActionPhaseSlicePrepareInterfaceConfigurationPhone(interfaceConfigurationPrevious: previous,
                                                                          interfaceConfigurationCurrent: current)
        }
    }
    
    func videoRecordEnter() {
        videoRecordGo(isEnabled: true)
    }
    
    func videoRecordExit() {
        videoRecordGo(isEnabled: false)
    }
    
    func videoRecordGo(isEnabled: Bool) {
        
        if jiggleViewModel.isVideoRecordEnabled == isEnabled {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.isVideoRecordEnabled = isEnabled
            configuration.isVideoExportEnabled = false
            return [ToolActionPhaseSliceSetVideoRecordMode(isVideoRecordEnabled: isEnabled),
                    ToolActionPhaseSliceSetVideoExportMode(isVideoExportEnabled: false)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func videoExportEnter() {
        videoExportGo(isEnabled: true)
    }
    
    func videoExportExit() {
        videoExportGo(isEnabled: false)
    }
    
    func videoExportGo(isEnabled: Bool) {
        if jiggleViewModel.isVideoExportEnabled == isEnabled {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.isVideoExportEnabled = isEnabled
            configuration.isVideoRecordEnabled = false
            return [ToolActionPhaseSliceSetVideoExportMode(isVideoExportEnabled: isEnabled),
                    ToolActionPhaseSliceSetVideoRecordMode(isVideoRecordEnabled: false)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func precisePointsEnter() {
        precisePointsGo(isEnabled: true)
    }
    
    func precisePointsExit() {
        precisePointsGo(isEnabled: false)
    }
    
    func precisePointsGo(isEnabled: Bool) {
        
        if jiggleViewModel.isPrecisePointsEnabled == isEnabled {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: false,
                                              changeCommand: { configuration in
            configuration.isPrecisePointsEnabled = isEnabled
            return [ToolActionPhaseSliceSetPrecisePointsMode(isPrecisePointsEnabled: isEnabled)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func renderOptionsEnter() {
            renderOptionsGo(isEnabled: true)
        }
        
        func renderOptionsExit() {
            renderOptionsGo(isEnabled: false)
        }
        
        func renderOptionsGo(isEnabled: Bool) {
            
            if jiggleViewModel.isRenderOptionsEnabled == isEnabled {
                return
            }
            
            if toolInterfaceViewModel.isBlocked { return }
            
            let toolAction = batchInterfaceAction(disableCreatorModes: false,
                                                  changeCommand: { configuration in
                configuration.isRenderOptionsEnabled = isEnabled
                return [ToolActionPhaseSliceSetRenderOptionsMode(isRenderOptionsEnabled: isEnabled)]
            }, alongsideMeshCommand: {
                [ ]
            })
            
            toolActionPerform(toolAction)
        }
    
    func animationLoopsEnter() {
        animationLoopsGo(isEnabled: true)
    }
    
    func animationLoopsExit() {
        animationLoopsGo(isEnabled: false)
    }
    
    func animationLoopsGo(isEnabled: Bool) {
        
        if jiggleViewModel.jiggleDocument.isAnimationLoopsEnabled == isEnabled {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.isAnimationLoopsEnabled = isEnabled
            return [ToolActionPhaseSliceSetAnimationLoopsMode(isAnimationLoopsMode: isEnabled)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func animationContinuousEnter() {
        animationContinuousGo(isEnabled: true)
    }
    
    func animationContinuousExit() {
        animationContinuousGo(isEnabled: false)
    }
    
    func animationContinuousGo(isEnabled: Bool) {
        
        if jiggleViewModel.jiggleDocument.isAnimationContinuousEnabled == isEnabled {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.isAnimationContinuousEnabled = isEnabled
            return [ToolActionPhaseSliceSetAnimationContinuousMode(isAnimationContinuousMode: isEnabled)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func animationContinuousPage1Enter() {
        animationContinuousPageGo(page: 1)
    }
    
    func animationContinuousPage2Enter() {
        animationContinuousPageGo(page: 2)
    }
    
    func animationContinuousPage3Enter() {
        animationContinuousPageGo(page: 3)
    }
    
    func animationContinuousPage2Exit() {
        animationContinuousPageGo(page: 1)
    }
    
    func animationContinuousPage3Exit() {
        animationContinuousPageGo(page: 2)
    }
    
    func animationContinuousPageGo(page: Int) {
        
        if jiggleViewModel.jiggleDocument.animationContinuousPage == page {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.animationContinuousPage = page
            return [ToolActionPhaseSliceSetContinuousPage(animationContinuousPage: page)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func animationTimeLinePage1Enter() {
        animationTimeLinePageGo(page: 1)
    }
    
    func animationTimeLinePage2Enter() {
        animationTimeLinePageGo(page: 2)
    }
    
    func animationTimeLinePage3Enter() {
        animationTimeLinePageGo(page: 3)
    }
    
    func animationTimeLinePage2Exit() {
        animationTimeLinePageGo(page: 1)
    }
    
    func animationTimeLinePage3Exit() {
        animationTimeLinePageGo(page: 2)
    }
    
    func animationTimeLinePageGo(page: Int) {
        
        if jiggleViewModel.jiggleDocument.animationTimeLinePage == page {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.animationTimeLinePage = page
            return [ToolActionPhaseSliceSetTimeLinePage(animationTimeLinePage: page)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    
    func animationLoopsPage1Enter() {
        animationLoopsPageGo(page: 1)
    }
    
    func animationLoopsPage2Enter() {
        animationLoopsPageGo(page: 2)
    }
    
    func animationLoopsPage3Enter() {
        animationLoopsPageGo(page: 3)
    }
    
    func animationLoopsPage2Exit() {
        animationLoopsPageGo(page: 1)
    }
    
    func animationLoopsPage3Exit() {
        animationLoopsPageGo(page: 2)
    }
    
    func animationLoopsPageGo(page: Int) {
        
        if jiggleViewModel.jiggleDocument.animationLoopsPage == page {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.animationLoopsPage = page
            return [ToolActionPhaseSliceSetLoopsPage(animationLoopsPage: page)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func graphPage1Enter() {
        graphPageGo(page: 1)
    }
    
    func graphPage2Enter() {
        graphPageGo(page: 2)
    }
    
    func graphPage3Enter() {
        graphPageGo(page: 3)
    }
    
    func graphPage2Exit() {
        graphPageGo(page: 1)
    }
    
    func graphPage3Exit() {
        graphPageGo(page: 2)
    }
    
    func graphPageGo(page: Int) {
        
        if jiggleViewModel.jiggleDocument.graphPage == page {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.graphPage = page
            return [ToolActionPhaseSliceSetGraphPage(graphPage: page)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func darkModeGo(isEnabled: Bool) {
        
        if ApplicationController.isDarkModeEnabled == isEnabled {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        var phases = [ToolActionPhase]()
        
        let phaseChangeCommand = ToolActionPhase(slices: [
            ToolActionPhaseSliceLockState(),
            ToolActionPhaseSliceSetDarkModeEnabled(isDarkModeEnabled: isEnabled)
        ])
        phases.append(phaseChangeCommand)
        
        let meshType = JiggleMeshCommand.getMeshTypeIfNeeded(documentMode: jiggleDocument.documentMode,
                                                             isGuidesEnabled: jiggleDocument.isGuidesEnabled)
        let swivelType = JiggleMeshCommand.getSwivelTypeIfNeeded(documentMode: jiggleDocument.documentMode,
                                                                 displayMode: jiggleViewModel.displayMode,
                                                                 isGuidesEnabled: jiggleDocument.isGuidesEnabled,
                                                                 isGraphEnabled: jiggleViewModel.isGraphEnabled)
        let weightCurveType = JiggleMeshCommand.getWeightCurveTypeIfNeeded(documentMode: jiggleDocument.documentMode,
                                                                           isGuidesEnabled: jiggleDocument.isGuidesEnabled,
                                                                           isGraphEnabled: jiggleViewModel.isGraphEnabled)
        let meshCommand = JiggleMeshCommand(spline: false,
                                            triangulationType: .fast,
                                            meshType: meshType,
                                            outlineType: .forced,
                                            swivelType: swivelType,
                                            weightCurveType: weightCurveType)
        let guideCommand = GuideCommand.none
        let phaseSliceMeshCommand = ToolActionPhaseSliceJiggleMeshCommandAllJiggles(meshCommand: meshCommand, guideCommand: guideCommand)
        
        let sliceUpdateToolbars = ToolActionPhaseSliceAnyClosure { [weak self] in
            if let self = self {
                self.toolInterfaceViewModel.publishDarkModeDidChange()
            }
            
        }
        let phaseMesh = ToolActionPhase(slices: [phaseSliceMeshCommand, sliceUpdateToolbars])
        
        phases.append(phaseMesh)
        
        let phaseUnlockState = ToolActionPhase(slices: [ToolActionPhaseSliceUnlockState()])
        phases.append(phaseUnlockState)
        
        let toolAction = ToolAction(phases: phases)
        toolActionPerform(toolAction)
    }
    
    func purchasedGo(isEnabled: Bool) {
        
        if ApplicationController.isPurchased == isEnabled {
            return
        }
        
        if toolInterfaceViewModel.isBlocked { return }
        
        var phases = [ToolActionPhase]()
        
        let phaseChangeCommand = ToolActionPhase(slices: [
            ToolActionPhaseSliceSetPurchasedEnabled(isPurchased: isEnabled)
        ])
        phases.append(phaseChangeCommand)
        
        let sliceUpdateToolbars = ToolActionPhaseSliceAnyClosure { [weak self] in
            if let self = self {
                self.toolInterfaceViewModel.publishPurchasedDidChange()
            }
            
        }
        let phaseToolbars = ToolActionPhase(slices: [sliceUpdateToolbars])
        
        phases.append(phaseToolbars)
        
        let toolAction = ToolAction(phases: phases)
        toolActionPerform(toolAction)
    }
    
    
    
    
    func timeLineEnter() {
        timeLineGo(isEnabled: true)
    }
    
    func timeLineExit() {
        timeLineGo(isEnabled: false)
    }
    
    func timeLineGo(isEnabled: Bool) {
        if jiggleViewModel.jiggleDocument.isTimeLineEnabled == isEnabled {
            return
        }
        if toolInterfaceViewModel.isBlocked {
            return
        }
        
        let toolAction = batchInterfaceAction(disableCreatorModes: true,
                                              changeCommand: { configuration in
            configuration.isTimeLineEnabled = isEnabled
            return [ToolActionPhaseSliceSetTimeLineMode(isTimeLineMode: isEnabled)]
        }, alongsideMeshCommand: {
            [ ]
        })
        
        toolActionPerform(toolAction)
    }
    
    func padMenuExpandedEnter() {
        padMenuExpandedGo(isEnabled: true)
    }
    
    func padMenuExpandedExit() {
        padMenuExpandedGo(isEnabled: false)
    }
    
    func padMenuExpandedGo(isEnabled: Bool) {
        
        if jiggleViewModel.isPadMenuExpanded == isEnabled { return }
        if toolInterfaceViewModel.isBlocked { return }
        if Device.isPhone { return }
        
        let interfaceConfigurationPrevious = toolInterfaceViewModel.getCurrentInterfaceConfigurationPad()
        var interfaceConfigurationCurrent = interfaceConfigurationPrevious
        let phaseSliceExpandedDraggable = ToolActionPhaseSliceSetExpandedDraggable(isExpanded: isEnabled)
        interfaceConfigurationCurrent.isExpanded = isEnabled
        let phaseSliceInterface = getInterfaceConfigurationUpdateSlice(
            previous: interfaceConfigurationPrevious,
            current: interfaceConfigurationCurrent)
        
        let slices = [phaseSliceInterface, phaseSliceExpandedDraggable]
        let phase = ToolActionPhase(slices: slices, time: 0.0)
        
        let toolAction = ToolAction(phase: phase)
        toolActionPerform(toolAction)
        
        
        //toolInterfaceViewModel.handleJiggleSpeedDidChange()
        //toolInterfaceViewModel.handleJigglePowerDidChange()
        
    }
    
    func animateMenuExpandedPhone(configurationPrevious: InterfaceConfigurationPhone,
                                  configurationCurrent: InterfaceConfigurationPhone,
                                  snapMenus: Bool,
                                  time: CGFloat) {
        
        
        print("[$$$$$$] animateMenuExpandedPhone => About To Execute!!!")
        
        let safeAreaTop: Int
        let safeAreaBottom: Int
        if let rootViewController = ApplicationController.rootViewController {
            safeAreaTop = Int(rootViewController.view.safeAreaInsets.top + 0.5)
            safeAreaBottom = Int(rootViewController.view.safeAreaInsets.bottom + 0.5)
        } else {
            safeAreaTop = 0
            safeAreaBottom = 0
        }
        
        let orientation = jiggleDocument.orientation
        let topMenuHeight = MenuHeightCategoryPhoneTop.get(category: configurationCurrent.heightCategoryTop,
                                                           orientation: orientation)
        let bottomMenuHeight = MenuHeightCategoryPhoneBottom.get(category: configurationCurrent.heightCategoryBottom,
                                                                 orientation: orientation)
        
        let topMenuPosition: CGFloat
        if configurationCurrent.isExpandedTop {
            topMenuPosition = CGFloat(topMenuHeight + safeAreaTop)
        } else {
            topMenuPosition = CGFloat(-Self.phoneMenuCollapseOffset)
        }
        
        let bottomMenuPosition: CGFloat
        if configurationCurrent.isExpandedBottom {
            bottomMenuPosition = CGFloat(-bottomMenuHeight - safeAreaBottom)
        } else {
            bottomMenuPosition = CGFloat(Self.phoneMenuCollapseOffset)
        }
        
        if snapMenus {
            phoneTopMenu.snapExpanded(configuration: configurationCurrent, snapStandardMenus: true)
        }
        
        var isAnimatingTopIn = false
        var isAnimatingTopOut = false
        var isAnimatingTopLateral = false
        
        var isAnimatingBottomIn = false
        var isAnimatingBottomOut = false
        var isAnimatingBottomLateral = false
        
        
        if configurationPrevious.isExpandedTop == false && configurationCurrent.isExpandedTop == true {
            isAnimatingTopIn = true
        }
        if configurationPrevious.isExpandedTop == true && configurationCurrent.isExpandedTop == false {
            isAnimatingTopOut = true
        }
        if configurationPrevious.isExpandedBottom == false && configurationCurrent.isExpandedBottom == true {
            isAnimatingBottomIn = true
        }
        if configurationPrevious.isExpandedBottom == true && configurationCurrent.isExpandedBottom == false {
            isAnimatingBottomOut = true
        }
        
        let menuHeightTopPrevious = MenuHeightCategoryPhoneTop.get(category: configurationPrevious.heightCategoryTop,
                                                                   orientation: orientation) + safeAreaTop
        let menuHeightBottomPrevious = MenuHeightCategoryPhoneBottom.get(category: configurationPrevious.heightCategoryBottom,
                                                                         orientation: orientation) + safeAreaBottom
        
        
        let menuHeightTopCurrent = MenuHeightCategoryPhoneTop.get(category: configurationCurrent.heightCategoryTop,
                                                                  orientation: orientation) + safeAreaTop
        let menuHeightBottomCurrent = MenuHeightCategoryPhoneBottom.get(category: configurationCurrent.heightCategoryBottom,
                                                                        orientation: orientation) + safeAreaBottom
        
        if menuHeightTopPrevious != menuHeightTopCurrent {
            if configurationPrevious.isExpandedTop == true && configurationCurrent.isExpandedTop == true {
                isAnimatingTopLateral = true
            }
        }
        
        if menuHeightBottomPrevious != menuHeightBottomCurrent {
            
            if configurationPrevious.isExpandedBottom == true && configurationCurrent.isExpandedBottom == true {
                isAnimatingBottomLateral = true
            }
        }
        
        if isAnimatingTopOut {
            phoneExpandToolbarButtonTop.transform = CGAffineTransform(translationX: 0.0,
                                                                      y: CGFloat(menuHeightTopPrevious - safeAreaTop))
        } else if isAnimatingTopIn {
            phoneExpandToolbarButtonTop.transform = CGAffineTransform.identity
            
        }
        
        if isAnimatingBottomOut {
            phoneExpandToolbarButtonBottom.transform = CGAffineTransform(translationX: 0.0,
                                                                         y: CGFloat(-menuHeightBottomPrevious + safeAreaBottom))
        } else if isAnimatingBottomIn {
            phoneExpandToolbarButtonBottom.transform = CGAffineTransform.identity
        }
        
        if configurationCurrent.isExpandedTop {
            if phoneExpandToolbarButtonTop.isUpArrow == true {
                phoneExpandToolbarButtonTop.isUpArrow = false
                phoneExpandToolbarButtonTop.setNeedsDisplay()
                phoneExpandToolbarButtonTop.renderContent.setNeedsDisplay()
            }
        } else {
            if phoneExpandToolbarButtonTop.isUpArrow == false {
                phoneExpandToolbarButtonTop.isUpArrow = true
                phoneExpandToolbarButtonTop.setNeedsDisplay()
                phoneExpandToolbarButtonTop.renderContent.setNeedsDisplay()
            }
        }
        
        if configurationCurrent.isExpandedBottom {
            if phoneExpandToolbarButtonBottom.isUpArrow == false {
                phoneExpandToolbarButtonBottom.isUpArrow = true
                phoneExpandToolbarButtonBottom.setNeedsDisplay()
                phoneExpandToolbarButtonBottom.renderContent.setNeedsDisplay()
            }
        } else {
            if phoneExpandToolbarButtonBottom.isUpArrow == true {
                phoneExpandToolbarButtonBottom.isUpArrow = false
                phoneExpandToolbarButtonBottom.setNeedsDisplay()
                phoneExpandToolbarButtonBottom.renderContent.setNeedsDisplay()
            }
        }
        
        isMenuExpandCollapseAnimating = true
        UIView.animate(withDuration: TimeInterval(time), delay: 0.0, options: .curveLinear, animations: {
            self.phoneTopMenuPositionConstraint.constant = CGFloat(topMenuPosition)
            self.phoneBottomMenuPositionConstraint.constant = CGFloat(bottomMenuPosition)
            
            if isAnimatingTopOut {
                self.phoneExpandToolbarButtonTop.transform = CGAffineTransform.identity
                
            } else if isAnimatingTopIn {
                self.phoneExpandToolbarButtonTop.transform = CGAffineTransform(translationX: 0.0,
                                                                               y: CGFloat(menuHeightTopCurrent - safeAreaTop))
                
            } else if isAnimatingTopLateral {
                self.phoneExpandToolbarButtonTop.transform = CGAffineTransform(translationX: 0.0,
                                                                               y: CGFloat(menuHeightTopCurrent - safeAreaTop))
                
            }
            if isAnimatingBottomOut {
                self.phoneExpandToolbarButtonBottom.transform = CGAffineTransform.identity
            } else if isAnimatingBottomIn {
                self.phoneExpandToolbarButtonBottom.transform = CGAffineTransform(translationX: 0.0,
                                                                                  y: CGFloat(-menuHeightBottomCurrent + safeAreaBottom))
            } else if isAnimatingBottomLateral {
                self.phoneExpandToolbarButtonBottom.transform = CGAffineTransform(translationX: 0.0,
                                                                                  y: CGFloat(-menuHeightBottomCurrent + safeAreaBottom))
            }
            self.view.layoutIfNeeded()
        }) { _ in
            self.isMenuExpandCollapseAnimating = false
        }
    }
    
    func snapMenuExpandedPhone(configuration: InterfaceConfigurationPhone,
                               snapMenus: Bool) {
        
        let safeAreaTop: Int
        let safeAreaBottom: Int
        if let rootViewController = ApplicationController.rootViewController {
            safeAreaTop = Int(rootViewController.view.safeAreaInsets.top + 0.5)
            safeAreaBottom = Int(rootViewController.view.safeAreaInsets.bottom + 0.5)
        } else {
            safeAreaTop = 0
            safeAreaBottom = 0
        }
        
        let orientation = jiggleDocument.orientation
        let topMenuHeight = MenuHeightCategoryPhoneTop.get(category: configuration.heightCategoryTop,
                                                           orientation: orientation)
        let bottomMenuHeight = MenuHeightCategoryPhoneBottom.get(category: configuration.heightCategoryBottom,
                                                                 orientation: orientation)
        
        let topMenuPosition: CGFloat
        if configuration.isExpandedTop {
            topMenuPosition = CGFloat(topMenuHeight + safeAreaTop)
        } else {
            topMenuPosition = CGFloat(-Self.phoneMenuCollapseOffset)
        }
        
        let bottomMenuPosition: CGFloat
        if configuration.isExpandedBottom {
            bottomMenuPosition = CGFloat(-bottomMenuHeight - safeAreaBottom)
        } else {
            bottomMenuPosition = CGFloat(Self.phoneMenuCollapseOffset)
        }
        
        phoneTopMenuPositionConstraint.constant = CGFloat(topMenuPosition)
        phoneBottomMenuPositionConstraint.constant = CGFloat(bottomMenuPosition)
        
        phoneTopMenu.snapExpanded(configuration: configuration,
                                  snapStandardMenus: snapMenus)
        phoneBottomMenu.snapExpanded(configuration: configuration,
                                     snapStandardMenus: snapMenus)
        
        if configuration.isExpandedTop {
            phoneExpandToolbarButtonTop.transform = CGAffineTransform(translationX: 0.0,
                                                                      y: CGFloat(topMenuHeight))
            
        } else {
            phoneExpandToolbarButtonTop.transform = CGAffineTransform.identity
        }
        
        if configuration.isExpandedBottom {
            phoneExpandToolbarButtonBottom.transform = CGAffineTransform(translationX: 0.0,
                                                                         y: CGFloat(-bottomMenuHeight))
            
        } else {
            phoneExpandToolbarButtonBottom.transform = CGAffineTransform.identity
        }
        
        if configuration.isExpandedTop {
            if phoneExpandToolbarButtonTop.isUpArrow == true {
                phoneExpandToolbarButtonTop.isUpArrow = false
                phoneExpandToolbarButtonTop.setNeedsDisplay()
                phoneExpandToolbarButtonTop.renderContent.setNeedsDisplay()
            }
        } else {
            if phoneExpandToolbarButtonTop.isUpArrow == false {
                phoneExpandToolbarButtonTop.isUpArrow = true
                phoneExpandToolbarButtonTop.setNeedsDisplay()
                phoneExpandToolbarButtonTop.renderContent.setNeedsDisplay()
            }
        }
        
        if configuration.isExpandedBottom {
            if phoneExpandToolbarButtonBottom.isUpArrow == false {
                phoneExpandToolbarButtonBottom.isUpArrow = true
                phoneExpandToolbarButtonBottom.setNeedsDisplay()
                phoneExpandToolbarButtonBottom.renderContent.setNeedsDisplay()
            }
        } else {
            if phoneExpandToolbarButtonBottom.isUpArrow == true {
                phoneExpandToolbarButtonBottom.isUpArrow = false
                phoneExpandToolbarButtonBottom.setNeedsDisplay()
                phoneExpandToolbarButtonBottom.renderContent.setNeedsDisplay()
            }
        }
        
        isMenuExpandCollapseAnimating = false
    }
    
    func animateMenuExpandedPad(configurationPrevious: InterfaceConfigurationPad,
                                configurationCurrent: InterfaceConfigurationPad,
                                snapMenus: Bool,
                                time: CGFloat) {
        
        let menuHeight = MenuHeightCategoryPad.get(category: configurationCurrent.heightCategory,
                                                   orientation: jiggleDocument.orientation,
                                                   isExpanded: configurationCurrent.isExpanded)
        
        if (configurationPrevious.isExpanded == true) && (configurationCurrent.isExpanded == true) {
            if snapMenus {
                padDraggableMenu.snapExpanded(configuration: configurationCurrent, snapStandardMenus: true)
            }
            
            isMenuExpandCollapseAnimating = true
            UIView.animate(withDuration: TimeInterval(time), delay: 0.0, options: .curveLinear, animations: {
                
                self.padDraggableMenuHeightConstraint.constant = CGFloat(menuHeight)
                self.view.layoutIfNeeded()
                
            }) { _ in
                self.isMenuExpandCollapseAnimating = false
            }
            
        } else {
            // Neither state is expanded, do nothing...
            print("*** FATAL *** IPAD *** Should ***NOT*** Call animateMenuExpandedPad Unless Expanded")
        }
    }
    
    func snapMenuExpandedPad(configuration: InterfaceConfigurationPad,
                             snapMenus: Bool) {
        let height = MenuHeightCategoryPad.get(category: configuration.heightCategory,
                                               orientation: jiggleDocument.orientation,
                                               isExpanded: configuration.isExpanded)
        padDraggableMenuHeightConstraint.constant = CGFloat(height)
        padDraggableMenu.snapExpanded(configuration: configuration, snapStandardMenus: snapMenus)
        isMenuExpandCollapseAnimating = false
    }
    
    func graphUpdateRelay(jiggle: Jiggle?) {
        
        var isDisplayNeeded = false
        
        if jiggleViewModel.isGraphMode {
            isDisplayNeeded = true
        }
        
        if let jiggle = jiggle {
            if Device.isPad {
                padDraggableMenu.standardContainerView.graphContainerView.graphView.weightCurve = jiggle.weightCurve
                padDraggableMenu.standardContainerView.graphContainerView.graphView.jiggle = jiggle
                if isDisplayNeeded {
                    padDraggableMenu.standardContainerView.graphContainerView.graphView.setNeedsDisplay()
                }
            } else {
                phoneTopMenu.standardContainerView.graphContainerView.graphView.weightCurve = jiggle.weightCurve
                phoneTopMenu.standardContainerView.graphContainerView.graphView.jiggle = jiggle
                if isDisplayNeeded {
                    phoneTopMenu.standardContainerView.graphContainerView.graphView.setNeedsDisplay()
                }
            }
        } else {
            if Device.isPad {
                padDraggableMenu.standardContainerView.graphContainerView.graphView.weightCurve = nil
                padDraggableMenu.standardContainerView.graphContainerView.graphView.jiggle = nil
                if isDisplayNeeded {
                    padDraggableMenu.standardContainerView.graphContainerView.graphView.setNeedsDisplay()
                }
            } else {
                phoneTopMenu.standardContainerView.graphContainerView.graphView.weightCurve = nil
                phoneTopMenu.standardContainerView.graphContainerView.graphView.jiggle = nil
                if isDisplayNeeded {
                    phoneTopMenu.standardContainerView.graphContainerView.graphView.setNeedsDisplay()
                }
            }
        }
    }
    
    func timeLineUpdateRelay(jiggle: Jiggle?) {
        
        var isDisplayNeeded = false
        if jiggleDocument.isTimeLineMode {
            isDisplayNeeded = true
        }
        
        if let jiggle = jiggle {
            
            jiggle.refreshTimeLine()
            
            if Device.isPad {
                padDraggableMenu.standardContainerView.timeLineContainerView.timeLineView.jiggle = jiggle
                if isDisplayNeeded {
                    padDraggableMenu.standardContainerView.timeLineContainerView.timeLineView.setNeedsDisplay()
                }
                padDraggableMenu.standardContainerView.timeLineContainerView.handleSelectedSwatchDidChange()
            } else {
                phoneTopMenu.standardContainerView.timeLineContainerView.timeLineView.jiggle = jiggle
                if isDisplayNeeded {
                    phoneTopMenu.standardContainerView.timeLineContainerView.timeLineView.setNeedsDisplay()
                }
                phoneTopMenu.standardContainerView.timeLineContainerView.handleSelectedSwatchDidChange()
            }
        } else {
            if Device.isPad {
                padDraggableMenu.standardContainerView.timeLineContainerView.timeLineView.jiggle = nil
                if isDisplayNeeded {
                    padDraggableMenu.standardContainerView.timeLineContainerView.timeLineView.setNeedsDisplay()
                }
                padDraggableMenu.standardContainerView.timeLineContainerView.handleSelectedSwatchDidChange()
            } else {
                phoneTopMenu.standardContainerView.timeLineContainerView.timeLineView.jiggle = nil
                if isDisplayNeeded {
                    phoneTopMenu.standardContainerView.timeLineContainerView.timeLineView.setNeedsDisplay()
                }
                phoneTopMenu.standardContainerView.timeLineContainerView.handleSelectedSwatchDidChange()
            }
        }
    }
    
    @MainActor func sideMenuEnter() {
        if let jiggleContainerViewController = jiggleContainerViewController {
            jiggleContainerViewController.sideMenuEnter()
        }
        
    }
    
    @MainActor func sideMenuExit() {
        if let jiggleContainerViewController = jiggleContainerViewController {
            jiggleContainerViewController.sideMenuExit()
        }
    }
    
    @MainActor func handleExit() {
        print("JiggleViewController.handleExit()")
        jiggleViewModel.handleExit()
    }
    
    @MainActor func applicationWillResignActive() {
        print("JiggleViewController.applicationWillResignActive")
        jiggleViewModel.applicationWillResignActive()
    }
    
    @MainActor func applicationDidBecomeActive() {
        print("JiggleViewController.applicationDidBecomeActive")
        jiggleViewModel.applicationDidBecomeActive()
    }
    
    @MainActor func handleDarkModeDidChange() {
        jiggleViewModel.handleDarkModeDidChange()
        if Device.isPhone {
            phoneExpandToolbarButtonTop.setNeedsDisplay()
            phoneExpandToolbarButtonTop.renderContent.setNeedsDisplay()
            phoneExpandToolbarButtonBottom.setNeedsDisplay()
            phoneExpandToolbarButtonBottom.renderContent.setNeedsDisplay()
        }
    }
    
    @MainActor func handlePurchasedDidChange() {
        print("purchased...")
        
        toolInterfaceViewModel.reloadAllRows()
    }
    
}
