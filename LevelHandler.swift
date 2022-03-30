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

    func levelOne() {
        if let interactionLayer = inteactionLayer {
            let coin = Coin()
            interactionLayer.renderCoin(coin: coin)
        }
        
    }

    func levelTwo() {
    }

    func levelThree() {
    }

    func levelFour() {
    }

    func levelFive() {
    }

    func levelSix() {
    }

    func levelSeven() {
    }

    func levelEight() {
    }

    func levelNine() {
    }

    func levelTen() {
    }
}
