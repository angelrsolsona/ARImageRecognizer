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
    
}

class ViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
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
    
    func objetDrawByImage(imageAnchor:ARImageAnchor) -> (SCNNode,SCNAction?){
        
        guard let nameEnum = ARNameImagenes.init(rawValue: imageAnchor.name!) else {return (SCNNode(),SCNAction())}
        var node = SCNNode()
        switch nameEnum {
        case .pinguin:
            guard let objScene = SCNScene(named: "Art.scnassets/gaviota.scn"),
                let objNode = objScene.rootNode.childNode(withName: "gaviota", recursively: false)
                else {return (SCNNode(),SCNAction())}
            node = objNode
            break
        }
        
//        let (min, max) = node.boundingBox
//        let size = SCNVector3Make(max.x - min.x, max.y - min.y, max.z - min.z)
//
//        let widthRatio = Float(imageAnchor.referenceImage.physicalSize.width)/size.x
//        let heightRatio = Float(imageAnchor.referenceImage.physicalSize.height)/size.z
//        let finalRatio = [widthRatio, heightRatio].min()!
//
//        node.transform = SCNMatrix4(imageAnchor.transform)
        
        
//        let appearanceAction = SCNAction.scale(to: CGFloat(finalRatio), duration: 0.4)
//        appearanceAction.timingMode = .easeOut
        //node.scale = SCNVector3Make(0.001, 0.001, 0.001)
        
        node.position = SCNVector3Zero
        node.position.x = -2500
        node.position.z = -500
        
        
        return (node,nil)
    }


}

extension ViewController:ARSCNViewDelegate{
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        guard let imageAnchor = anchor as? ARImageAnchor else { return SCNNode() }
        let referenceImage = imageAnchor.referenceImage
        
            
            let plane = SCNPlane(width: referenceImage.physicalSize.width,
                                 height: referenceImage.physicalSize.height)
            let planeNode = SCNNode(geometry: plane)
            planeNode.opacity = 0.25
            
            planeNode.eulerAngles.x = -.pi / 2
            
            let (object,apparinceAction) = self.objetDrawByImage(imageAnchor: imageAnchor)
            planeNode.addChildNode(object)
            node.addChildNode(planeNode)
            self.sceneView.scene.rootNode.addChildNode(object)
//            object.runAction(apparinceAction)
            
            return node
        
    }
}
