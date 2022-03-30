import Igis
import Scenes
import Foundation

class LevelHandler : RenderableEntity {
    let marioSprite : Mario
    var currentLevel : Int
    var interactionLayer : InteractionLayer?
    
    init(mario:Mario) {
        marioSprite = mario
        currentLevel = 0
    }

    override func calculate(canvasSize: Size) {
        
    }

    func setHandler(handler:InteractionLayer) {
        interactionLayer = handler;
    }
}
