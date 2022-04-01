import Foundation
import Scenes
import Igis

/*
 This class is responsible for the interaction Layer.
 Internally, it maintains the RenderableEntities for this layer.
 */


class InteractionLayer : Layer, KeyDownHandler, KeyUpHandler {

    let marioSprite : Mario
    let levelHandler : LevelHandler
    
    init() {
        marioSprite = Mario(tiles:[])
        levelHandler = LevelHandler(mario:marioSprite)
        
        // Using a meaningful name can be helpful for debugging
        super.init(name:"Interaction")
        
        // We insert our RenderableEntities in the constructor
        insert(entity:marioSprite, at:.front)
    }
    
    override func preSetup(canvasSize: Size, canvas: Canvas) {
        marioSprite.move(to: Point(x:10, y:canvasSize.height-200-96))

        levelHandler.setHandler(handler: self)
        
        dispatcher.registerKeyDownHandler(handler: self)
        dispatcher.registerKeyUpHandler(handler: self)
    }

    override func postSetup(canvasSize:Size, canvas:Canvas) {
        
        levelHandler.levelOne(canvasSize: canvasSize)

    }

    override func postTeardown() {
        dispatcher.unregisterKeyDownHandler(handler: self)
        dispatcher.unregisterKeyUpHandler(handler: self)
    }

    var keysDown = [String]()
    
    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        keysDown.append(key)
//        print("down: "+code)
        if(key == "w" || key == "ArrowUp" || code == "Space") {
            marioSprite.jump()
        }
        if(key == "s" || key == "ArrowDown") {
            // crouch
        }

        if((keysDown.contains("a") || keysDown.contains("ArrowLeft")) && (keysDown.contains("d") || keysDown.contains("ArrowRight"))) {
            marioSprite.setVelocityX(new: 0.0)
        }
        else if(key == "a" || key == "ArrowLeft") {
            marioSprite.setVelocityX(new: -10.0)
        }
        else if(key == "d" || key == "ArrowRight") {
            marioSprite.setVelocityX(new: 10.0)
        }
    }

    func onKeyUp(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if (keysDown.contains(key)) {
            keysDown = keysDown.filter { $0 != key }
        }
        
        if((keysDown.contains("a") || keysDown.contains("ArrowLeft")) && (keysDown.contains("d") || keysDown.contains("ArrowRight"))) {
            marioSprite.setVelocityX(new: 0.0)
        }
        else if(keysDown.contains("a") || keysDown.contains("ArrowLeft")) {
            marioSprite.setVelocityX(new: -10.0)
        }
        else if(keysDown.contains("d") || keysDown.contains("ArrowRight")) {
            marioSprite.setVelocityX(new: 10.0)
        } else {
            marioSprite.setVelocityX(new: 0.0)
        }
    }

    func renderQuestionBlockTile(questionTile:QuestionBlockTile) {
        insert(entity:questionTile, at:.front)
    }
    
    func renderCoin(coin:Coin) {
        insert(entity:coin, at:.behind(object:marioSprite))
    }
}
