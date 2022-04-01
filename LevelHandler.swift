import Igis
import Scenes
import Foundation

class LevelHandler : RenderableEntity {
    let marioSprite : Mario
    var currentLevel : Int
    var interactionLayer : InteractionLayer?
    var score = 0
    
    init(mario:Mario) {
        marioSprite = mario
        currentLevel = 0
    }

    override func calculate(canvasSize: Size) {
        
    }

    override func render(canvas: Canvas) {
        let text = Text(location:Point(x:50, y:90), text:String(score))
        text.font = "30pt Arial"
        canvas.render(text)
    }

    func setHandler(handler:InteractionLayer) {
        interactionLayer = handler;
    }

    func setScore(value: Int) {
        score = value
    }

    func levelOne(canvasSize:Size) {
        if let interactionLayer = interactionLayer {
            let questionTile = QuestionBlockTile(whatInside:"coin")
            questionTile.setTopLeft(point: Point(x: canvasSize.width / 2, y: canvasSize.height - 200 - 96 - 100))
            let coin = Coin()
            coin.setRect(newRect: questionTile.rect)
            coin.setActive(value: false)

            questionTile.setInsideCoin(value: coin)
            questionTile.setLevelHandler(handler: self)
            
            interactionLayer.renderCoin(coin: coin)
            interactionLayer.renderQuestionBlockTile(questionTile: questionTile)

            interactionLayer.marioSprite.setBoxes(tiles: [questionTile])
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
