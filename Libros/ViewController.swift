//
//  ViewController.swift
//  Libros
//
//  Created by Angel Ricardo Solsona Nevero on 11/01/19.
//  Copyright © 2019 Angel Ricardo Solsona Nevero. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum ARNameImagenes: String {
    
    case pinguin = "pinguino"
    case tree = "tree"
    case book = "book"
    case mountain = "mountain"
    case seagull = "seagull"
    case wizard = "wizard"
    
}

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    
    let fadeDuration: TimeInterval = 0.3
    let rotateDuration: TimeInterval = 3
    let waitDuration: TimeInterval = 0.5
    
    lazy var fadeAndSpinAction: SCNAction = {
        return .sequence([
            .fadeIn(duration: fadeDuration),
            .rotateBy(x: 0, y: 0, z: CGFloat.pi * 360 / 180, duration: rotateDuration),
            .wait(duration: waitDuration)
//            .fadeOut(duration: fadeDuration)
            ])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) else {
            fatalError("Missing expected asset catalog resources.")
        }
        
        let configuration = ARImageTrackingConfiguration()
        configuration.trackingImages = referenceImages
        configuration.maximumNumberOfTrackedImages = 1
        sceneView.session.run(configuration, options: [.resetTracking,.removeExistingAnchors])
        sceneView.delegate = self
    }
    
    func objetDrawByImage(imageAnchor:ARImageAnchor) -> (SCNNode){
        
        guard let nameEnum = ARNameImagenes.init(rawValue: imageAnchor.name!) else {return SCNNode()}
        var node = SCNNode()
        switch nameEnum {
        case .pinguin:
            guard let objScene = SCNScene(named: "Art.scnassets/pinguin.scn"),
                let objNode = objScene.rootNode.childNode(withName: "pinguin", recursively: false)
                else {return SCNNode()}
            let scaleFactor = 0.001
            objNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
            objNode.eulerAngles.x = -.pi / 2
            node = objNode
            break
        case .tree:
            guard let scene = SCNScene(named: "Art.scnassets/tree.scn"),
                let objNode = scene.rootNode.childNode(withName: "tree", recursively: false) else { return SCNNode() }
            let scaleFactor = 0.005
            objNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
            objNode.eulerAngles.x = -.pi / 2
            node = objNode
            break
            
        case .book:
            
            guard let scene = SCNScene(named: "Art.scnassets/book.scn"),
                let objNode = scene.rootNode.childNode(withName: "book", recursively: false) else { return SCNNode() }
            let scaleFactor  = 0.01
            node.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
            node = objNode
            
            break
            
        case .mountain:
            
            guard let scene = SCNScene(named: "Art.scnassets/mountain.scn"),
                let objNode = scene.rootNode.childNode(withName: "mountain", recursively: false) else { return SCNNode() }
            let scaleFactor  = 0.25
            objNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
            objNode.eulerAngles.x += -.pi / 2
            node = objNode
            
            break
            
        case .seagull:
            guard let scene = SCNScene(named: "Art.scnassets/gaviota.scn"),
                let objNode = scene.rootNode.childNode(withName: "gaviota", recursively: false) else { return SCNNode() }
            let scaleFactor  = 0.0001
            objNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
            objNode.eulerAngles.x += -.pi / 2
            node = objNode
            break
        case .wizard:
            guard let scene = SCNScene(named: "Art.scnassets/wizard.scn"),
                let objNode = scene.rootNode.childNode(withName: "wizard", recursively: false) else { return SCNNode() }
            let scaleFactor  = 0.005
            objNode.scale = SCNVector3(scaleFactor, scaleFactor, scaleFactor)
            objNode.eulerAngles.x += -.pi / 2
            node = objNode
            break
        }
        return node
    }


}

extension ViewController:ARSCNViewDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//
        let node = SCNNode()

//            let plane = SCNPlane(width: referenceImage.physicalSize.width,
//                                 height: referenceImage.physicalSize.height)
//            let planeNode = SCNNode(geometry: plane)
//            planeNode.opacity = 0.25
//            planeNode.eulerAngles.x = -.pi / 2

        guard let imageAnchor = anchor as? ARImageAnchor else { return nil}
    
        let objectNode = self.objetDrawByImage(imageAnchor: imageAnchor)
        objectNode.opacity = 0
        objectNode.position.y = 0.2
        objectNode.runAction(self.fadeAndSpinAction)
        node.addChildNode(objectNode)
        return node
    }

}
