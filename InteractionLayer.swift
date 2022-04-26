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
        insert(entity:levelHandler, at:.front)
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
    var frozenKeysDown = [String]()

    func clearKeysDown() {
        frozenKeysDown = keysDown
        keysDown.removeAll()
    }

    func unclearKeysDown() {
        keysDown = frozenKeysDown
        frozenKeysDown.removeAll();

        if(levelHandler.lives <= 0) {
            return
        }

        if(keysDown.contains("w") || keysDown.contains("ArrowUp")) {
            marioSprite.jump()
        }

        if((keysDown.contains("a") || keysDown.contains("ArrowLeft")) && (keysDown.contains("d") || keysDown.contains("ArrowRight"))) {
            marioSprite.setVelocityX(new: 0.0)
        }
        else if(keysDown.contains("a") || keysDown.contains("ArrowLeft")) {
            marioSprite.setVelocityX(new: -10.0)
        }
        else if(keysDown.contains("d") || keysDown.contains("ArrowRight")) {
            marioSprite.setVelocityX(new: 10.0)
        }
    }

    // function for handling key presses
    func onKeyDown(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if(levelHandler.lives <= 0 || levelHandler.frozenTimer > 0) {
            frozenKeysDown.append(key)
            return;
        }
        
        keysDown.append(key)
//        print("down: "+code)
        if(key == "w" || key == "ArrowUp" || code == "Space") {
            marioSprite.jump()
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

    // function for handling key unpresses
    func onKeyUp(key:String, code:String, ctrlKey:Bool, shiftKey:Bool, altKey:Bool, metaKey:Bool) {
        if(levelHandler.lives <= 0 || levelHandler.frozenTimer > 0) {
            if(frozenKeysDown.contains(key)) {
                frozenKeysDown = frozenKeysDown.filter { $0 != key }
            }
            return;
        }
        
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

    func renderGoomba(goomba:Goomba) {
        insert(entity:goomba, at:.front)
    }

    func removeEntity(entity:RenderableEntity) {
        remove(entity:entity)
    }
}
