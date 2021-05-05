import UIKit
import SceneKit

public var revolutionSppedRate: CGFloat = 0.3
public var rotationSpeedRate: CGFloat = 1.0

public class MySpaceScene: SCNScene {
    public override init() {
        super.init()
        setUpScene()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpScene()
    }
    
    public func setUpScene() {
        background.contents = UIColor.black
        
        // Stars
        let starsParticleSystem = SCNParticleSystem(named: "Stars", inDirectory: nil)
        let starsNode = SCNNode()
        starsNode.addParticleSystem(starsParticleSystem!)
        rootNode.addChildNode(starsNode)
        
        // Light
        let strongLight = SCNLight()
        strongLight.intensity = 2200
        let strongLightNode = SCNNode()
        strongLightNode.light = strongLight
        rootNode.addChildNode(strongLightNode)
        
        let ambientLight = SCNLight()
        ambientLight.type = .ambient
        ambientLight.intensity = 200
        let ambientLightNode = SCNNode()
        ambientLightNode.light = ambientLight
        rootNode.addChildNode(ambientLightNode)
        
        
        // Sun
        let sunParticleSystem = SCNParticleSystem(named: "Fire", inDirectory: nil)
        let sunNode = SCNNode()
        sunNode.name = "sunNode"
        sunNode.addParticleSystem(sunParticleSystem!)
        sunNode.position = SCNVector3(x: 0, y: 0, z: -4)
        rootNode.addChildNode(sunNode)
        
        //Propeller
        let Propeller = SCNParticleSystem(named: "Propeller", inDirectory: nil)
        let propellerNode = SCNNode()
        propellerNode.name = "propellerNode"
        propellerNode.position = SCNVector3(x: 0, y: 3.65, z: -3.8)

        let propellerNode1 = SCNNode()
        propellerNode1.addParticleSystem(Propeller!)
        propellerNode1.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
//        propellerNode1.position = SCNVector3(x: 0, y: 3.65, z: -3.8)
        propellerNode1.position = SCNVector3(x: 0, y: 0, z: 0)
        propellerNode.addChildNode(propellerNode1)
        
        let propellerNode2 = SCNNode()
        propellerNode2.addParticleSystem(Propeller!)
        propellerNode2.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
//        propellerNode2.position = SCNVector3(x: 0, y: 3.65, z: -4.2)
        propellerNode2.position = SCNVector3(x: 0, y: 0, z: -0.4)
        propellerNode.addChildNode(propellerNode2)
        
        let propellerNode3 = SCNNode()
        propellerNode3.addParticleSystem(Propeller!)
        propellerNode3.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
//        propellerNode3.position = SCNVector3(x: 0.2, y: 3.65, z: -4)
        propellerNode3.position = SCNVector3(x: 0.2, y: 0, z: -0.2)
        propellerNode.addChildNode(propellerNode3)
        
        let propellerNode4 = SCNNode()
        propellerNode4.addParticleSystem(Propeller!)
        propellerNode4.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
//        propellerNode4.position = SCNVector3(x: -0.2, y: 3.65, z: -4)
        propellerNode4.position = SCNVector3(x: -0.2, y: 0, z: -0.2)
        propellerNode.addChildNode(propellerNode4)
        
        rootNode.addChildNode(propellerNode)
        
        // Earth
        let earthNode = SCNNode()
        earthNode.name = "earthNode"
        let earthSphere = SCNSphere(radius: 0.35)
        earthSphere.materials.first?.diffuse.contents = UIImage(named: "Earth.jpg")
        earthNode.geometry = earthSphere
        earthNode.position = SCNVector3(x: 0, y: 3.5, z: -4)
        earthNode.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: rotationSpeedRate * CGFloat.pi, z: 0, duration: 5)))
        rootNode.addChildNode(earthNode)
        
    }
}

