import UIKit
import ARKit
import SceneKit
import AVFoundation
import PlaygroundSupport

public var gameDifficulty = 1

public class SceneViewController: UIViewController {
    var backgroundMusicPlayer = AVAudioPlayer()
    
    var resultMusicPlayer = AVAudioPlayer()
    
    let introduceSceneBackgroundView = UIView()
    var currentScene = 1
    
    let firstSceneBackgroundImageView = UIImageView(image: UIImage(named: "firstSceneBackgroundImage"))
    let secondSceneBackgroundImageView = UIImageView(image: UIImage(named: "secondSceneBackgroundImage"))
    
    let firstSceneLabelImageView = UIImageView(image: UIImage(named: "firstSceneLabelImage"))
    let starView = UIImageView(image: UIImage(named: "introduceSceneStar"))
    
    let introduceLabel = UILabel()
    
    let nextButton = UIButton()
    
    var timer: Timer!
    var stayFlag = false
    var sceneView = ARSCNView()
    let mySpaceScene = MySpaceScene()
    lazy var mySpaceNode = mySpaceScene.rootNode
    
    var placeFlag = true
    
    var secondsToCountDown = 10
    var currentNumber: Int = 0 {
        didSet {
            if currentNumber == 0 {
                timesUp()
            }
        }
    }
    var countDownTimer: Timer!
    let countDownlabel = UILabel()
    let cardView = UIView()
    
    let gameView = UIView()
    
    let questionCard1 = UILabel()
    let questionCard2 = UILabel()
    let questionCard3 = UILabel()
    let questionCard4 = UILabel()
    let questionCard5 = UILabel()
    let questionCard6 = UILabel()
    
    var questionCards = [UILabel]()
    
    let answerCard1 = UIButton()
    let answerCard2 = UIButton()
    let answerCard3 = UIButton()
    let answerCard4 = UIButton()
    
    var answerCards = [UIButton]()
    
    let gameTitleLabel = UILabel()
    
    let gameRuleLabel = UILabel()
    
    let questionStackView = UIView()
    let answerStackView = UIView()
    
    let timeLabel = UILabel()
    let distanceLabel = UILabel()
    
    var question = [Int]()
    var answer = 0
    var answerNumber = 0
    
    var timeLeft = 30.0
    var distanceLeft = 3000
    
    var currentTimeLeft = 30.0 {
        didSet {
            if currentTimeLeft <= 0.0 {
                gameOver()
            }
        }
    }
    
    var currentDistanceLeft = 3000 {
        didSet {
            if currentDistanceLeft <= 0 {
                gameOver()
            } else if currentDistanceLeft >= 5000 {
                success()
            }
        }
    }
    
    var gameTimer: Timer!
    
    var questionSolved = 0
    
    let fireworkBackgroundView = UIView()
    
    let resultImageView = UIImageView(image: UIImage(named: "succeed"))
    
    let retryButton = UIButton()
    
    public override func loadView() {
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "backgroundMusic", ofType: "mp3")!))
            backgroundMusicPlayer.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
        
        self.view = introduceSceneBackgroundView
        
        firstSceneBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstSceneBackgroundImageView)
        
        firstSceneLabelImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(firstSceneLabelImageView)
        
        starView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(starView)
        
        nextButton.setTitle("Next  >", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Avenir", size: 20)?.bold()
        nextButton.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        nextButton.backgroundColor = UIColor(white: 1, alpha: 0.4)
        nextButton.layer.cornerRadius = 20
        nextButton.clipsToBounds = true
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(changeToNextScene), for: .touchUpInside)
        view.addSubview(nextButton)
        
        retryButton.setBackgroundImage(UIImage(named: "retry"), for: .normal)
        retryButton.setTitle("", for: .normal)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.addTarget(self, action: #selector(retry), for: .touchUpInside)
        
        timeLabel.text = "Time: 00.0s"
        timeLabel.font = UIFont(name: "Avenir", size: 15)?.bold()
        timeLabel.textAlignment = .center
        timeLabel.layer.cornerRadius = 20
        timeLabel.clipsToBounds = true
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        timeLabel.textColor = #colorLiteral(red: 0.07843137255, green: 0.262745098, blue: 0.4862745098, alpha: 1)
        timeLabel.alpha = 0.9
        
        distanceLabel.text = "Distance: 8888km"
        distanceLabel.font = UIFont(name: "Avenir", size: 15)?.bold()
        distanceLabel.textAlignment = .center
        distanceLabel.layer.cornerRadius = 20
        distanceLabel.clipsToBounds = true
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        distanceLabel.textColor = #colorLiteral(red: 0.07843137255, green: 0.262745098, blue: 0.4862745098, alpha: 1)
        distanceLabel.alpha = 0.9
        
        NSLayoutConstraint.activate([
            firstSceneBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            firstSceneBackgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            firstSceneBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            firstSceneBackgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            
            firstSceneLabelImageView.centerXAnchor.constraint(equalTo: introduceSceneBackgroundView.centerXAnchor),
            firstSceneLabelImageView.centerYAnchor.constraint(equalTo: introduceSceneBackgroundView.centerYAnchor, constant: 5),
            firstSceneLabelImageView.widthAnchor.constraint(equalToConstant: 250),
            firstSceneLabelImageView.heightAnchor.constraint(equalToConstant: 250),
            
            starView.centerXAnchor.constraint(equalTo: introduceSceneBackgroundView.centerXAnchor, constant: -60),
            starView.centerYAnchor.constraint(equalTo: firstSceneLabelImageView.centerYAnchor, constant: -230),
            starView.widthAnchor.constraint(equalToConstant: 240),
            starView.heightAnchor.constraint(equalToConstant: 220),
            
            nextButton.rightAnchor.constraint(equalTo: introduceSceneBackgroundView.rightAnchor, constant: -30),
            nextButton.bottomAnchor.constraint(equalTo: introduceSceneBackgroundView.bottomAnchor, constant: -30),
            nextButton.widthAnchor.constraint(equalToConstant: 125),
            nextButton.heightAnchor.constraint(equalToConstant: 60),
            
            ])
        backgroundMusicPlayer.play()
    }
    
    @objc func changeToNextScene() {
        if currentScene == 1 {
            currentScene += 1
            
            nextButton.isEnabled = false
            
            secondSceneBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(secondSceneBackgroundImageView)
            
            let attributedText = NSMutableAttributedString(string: "Today is June 3, 2050.\n",
                                                           attributes: [
                                                            .font: UIFont(name: "Avenir", size: 28)?.bold(),
                                                            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 0.6470588235, alpha: 1),
                                                            ])
            
            attributedText.append(NSAttributedString(string: "And\n",
                                                     attributes: [
                                                        .font: UIFont(name: "Avenir", size: 28)?.bold(),
                                                        .foregroundColor: UIColor.white,
                                                        ]))
            
            attributedText.append(NSAttributedString(string: "My name is Earth.",
                                                     attributes: [
                                                        .font: UIFont(name: "Avenir", size: 28)?.bold(),
                                                        .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 0.6470588235, alpha: 1),
                                                        ]))
            
            introduceLabel.attributedText = attributedText
            introduceLabel.numberOfLines = 0
            introduceLabel.textAlignment = .center
            introduceLabel.translatesAutoresizingMaskIntoConstraints = false
            introduceLabel.alpha = 0.0
            view.addSubview(introduceLabel)
            
            view.bringSubviewToFront(starView)
            view.bringSubviewToFront(nextButton)
            view.bringSubviewToFront(firstSceneLabelImageView)
            view.bringSubviewToFront(introduceLabel)
            
            NSLayoutConstraint.activate([
                secondSceneBackgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                secondSceneBackgroundImageView.rightAnchor.constraint(equalTo: view.rightAnchor),
                secondSceneBackgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                secondSceneBackgroundImageView.leftAnchor.constraint(equalTo: view.leftAnchor),
                
                introduceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                introduceLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                introduceLabel.widthAnchor.constraint(equalToConstant: 320),
                
                ])
            
            secondSceneBackgroundImageView.transform = CGAffineTransform(translationX: 0, y: 500)
            UIView.animate(withDuration: 1.2) {
                self.firstSceneLabelImageView.transform = CGAffineTransform(translationX: 300, y: 0)
                self.firstSceneLabelImageView.alpha = 0.0
            }
            
            UIView.animate(withDuration: 1.2,
                           animations: {
                            self.firstSceneBackgroundImageView.transform = CGAffineTransform(translationX: 0, y: -400)
                            self.secondSceneBackgroundImageView.transform = .identity
            },
                           completion: { _ in UIView.animate(withDuration: 0.5,
                                                             animations: { self.introduceLabel.alpha = 1.0 },
                                                             completion: { _ in self.nextButton.isEnabled = true })
            })
        } else if currentScene == 2 {
            currentScene += 1
            
            nextButton.isEnabled = false
            
            UIView.animate(withDuration: 1.2,
                           animations: {
                            self.introduceLabel.transform = CGAffineTransform(translationX: 300, y: 0)
                            self.introduceLabel.alpha = 0.0
            },
                           completion: { _ in
                            self.introduceLabel.transform = .identity
                            let attributedText = NSMutableAttributedString(string: "Your mission is to\n",
                                                                           attributes: [
                                                                            .font: UIFont(name: "Avenir", size: 28)?.bold(),
                                                                            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
                                                                            ])
                            attributedText.append(NSAttributedString(string: "help me escape from the solar system.",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 28)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 0.6470588235, alpha: 1),
                                                                        ]))
                            self.introduceLabel.attributedText = attributedText
                            UIView.animate(withDuration: 0.5,
                                           animations: { self.introduceLabel.alpha = 1.0 },
                                           completion: { _ in self.nextButton.isEnabled = true })
            })
            
        } else if currentScene == 3 {
            currentScene += 1
            
            nextButton.isEnabled = false
            
            UIView.animate(withDuration: 1.2,
                           animations: {
                            self.introduceLabel.transform = CGAffineTransform(translationX: 300, y: 0)
                            self.introduceLabel.alpha = 0.0
            },
                           completion: { _ in
                            self.introduceLabel.transform = .identity
                            let attributedText = NSMutableAttributedString(string: "I am now ",
                                                                           attributes: [
                                                                            .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                            .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                                                            ])
                            attributedText.append(NSAttributedString(string: "3,000 ",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 0.6470588235, alpha: 1),
                                                                        ]))
                            
                            attributedText.append(NSAttributedString(string: "kilometers from the sun.\n\n",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                                                        ]))
                            attributedText.append(NSAttributedString(string: "And approach the sun at a speed of ",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                                                        ]))
                            attributedText.append(NSAttributedString(string: "100",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 0.6470588235, alpha: 1),
                                                                        ]))
                            attributedText.append(NSAttributedString(string: " kilometers per second.",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                                                        ]))
                            
                            self.introduceLabel.attributedText = attributedText
                            UIView.animate(withDuration: 0.5,
                                           animations: { self.introduceLabel.alpha = 1.0 },
                                           completion: { _ in self.nextButton.isEnabled = true })
            })
            
        } else if currentScene == 4 {
            currentScene += 1
            
            nextButton.isEnabled = false
            
            UIView.animate(withDuration: 1.2,
                           animations: {
                            self.introduceLabel.transform = CGAffineTransform(translationX: 300, y: 0)
                            self.introduceLabel.alpha = 0.0
            },
                           completion: { _ in
                            self.introduceLabel.transform = .identity
                            let attributedText = NSMutableAttributedString(string: "Every time you solve a problem, ",
                                                                           attributes: [
                                                                            .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                            .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                                                            ])
                            attributedText.append(NSAttributedString(string: "I will stay away from the sun for",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                                                        ]))
                            
                            attributedText.append(NSAttributedString(string: " 600",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 0.6470588235, alpha: 1),
                                                                        ]))
                            attributedText.append(NSAttributedString(string: " kilometers.\n\n",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                                                        ]))
                            attributedText.append(NSAttributedString(string: "As long as I am ",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                                                        ]))
                            attributedText.append(NSAttributedString(string: "5000 ",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 0.6470588235, alpha: 1),
                                                                        ]))
                            attributedText.append(NSAttributedString(string: "kilometers away from the sun,\n",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                                                        ]))
                            attributedText.append(NSAttributedString(string: "I will no longer be controlled by it.",
                                                                     attributes: [
                                                                        .font: UIFont(name: "Avenir", size: 22)?.bold(),
                                                                        .foregroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0),
                                                                        ]))
                            
                            self.introduceLabel.attributedText = attributedText
                            UIView.animate(withDuration: 0.5,
                                           animations: { self.introduceLabel.alpha = 1.0 },
                                           completion: { _ in self.nextButton.isEnabled = true })
            })
            
        } else if currentScene == 5 {
            currentScene += 1
            
            self.nextButton.isEnabled = false
            
            UIView.animate(withDuration: 1.2,
                           animations: {
                            self.introduceLabel.transform = CGAffineTransform(translationX: 300, y: 0)
                            self.introduceLabel.alpha = 0.0
            },
                           completion: { _ in
                            self.introduceLabel.transform = .identity
                            let attributedText = NSMutableAttributedString(string: "Are you ready to help me?",
                                                                           attributes: [
                                                                            .font: UIFont(name: "Avenir", size: 28)?.bold(),
                                                                            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 0.6470588235, alpha: 1),
                                                                            ])
                            self.introduceLabel.attributedText = attributedText
                            self.nextButton.setTitle("Let's Start!", for: .normal)
                            UIView.animate(withDuration: 0.5,
                                           animations: { self.introduceLabel.alpha = 1.0 },
                                           completion: { _ in
                                            self.nextButton.isEnabled = true
                                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.scaleIntroduceLabel), userInfo: nil, repeats: true)
                                            self.timer.fire()
                            })
            })
            
        } else if currentScene == 6 {
            currentScene += 1
            
            self.timer.invalidate()
            
            self.sceneView.delegate = self
            self.sceneView.scene = SCNScene()
            self.view = self.sceneView
            
            let configuration = ARWorldTrackingConfiguration()
            configuration.planeDetection = .horizontal
            self.sceneView.session.run(configuration)
            
            self.sceneView.addSubview(self.nextButton)
            
            NSLayoutConstraint.activate([
                self.nextButton.rightAnchor.constraint(equalTo: self.sceneView.rightAnchor, constant: -30),
                self.nextButton.bottomAnchor.constraint(equalTo: self.sceneView.bottomAnchor, constant: -30),
                self.nextButton.widthAnchor.constraint(equalToConstant: 125),
                self.nextButton.heightAnchor.constraint(equalToConstant: 60),
                
                ])
            
            UIView.animate(withDuration: 1.2,
                           animations: { self.nextButton.alpha = 0.0 },
                           completion: { _ in
                            self.introduceLabel.alpha = 0.0
                            let attributedText = NSMutableAttributedString(string: "First find a plane\nAnd place me in the real world!",
                                                                           attributes: [
                                                                            .font: UIFont(name: "Avenir", size: 28)?.bold(),
                                                                            .foregroundColor: #colorLiteral(red: 1, green: 1, blue: 0.6470588235, alpha: 1),
                                                                            ])
                            
                            self.introduceLabel.attributedText = attributedText
                            self.introduceLabel.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                            self.introduceLabel.textColor = UIColor(red: 20/255, green: 67/255, blue: 124/255, alpha: 1)
                            self.introduceLabel.layer.cornerRadius = 25
                            self.introduceLabel.clipsToBounds = true
                            self.view.addSubview(self.introduceLabel)
                            
                            NSLayoutConstraint.activate([
                                self.introduceLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                                self.introduceLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                                self.introduceLabel.widthAnchor.constraint(equalToConstant: 300),
                                self.introduceLabel.heightAnchor.constraint(equalToConstant: 160),
                                ])
                            
                            UIView.animate(withDuration: 0.8, animations: {
                                self.introduceLabel.alpha = 0.9
                            }, completion: { _ in
                                self.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(self.introduceLabelStay), userInfo: nil, repeats: true)
                                self.timer.fire()
                            })
                            
            })
        } else if currentScene >= 7 {
            if nextButton.titleLabel?.text == "Space  >" {
                nextButton.setTitle("Back  >", for: .normal)
                UIView.animate(withDuration: 0.6) {
                    self.gameView.alpha = 0.0
                }
            } else if nextButton.titleLabel?.text == "Back  >" {
                nextButton.setTitle("Space  >", for: .normal)
                UIView.animate(withDuration: 0.6) {
                    self.gameView.alpha = 0.9
                }
            }
        }
    }
    
    @objc func scaleIntroduceLabel() {
        UIView.animate(withDuration: 0.3, animations: { self.introduceLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in UIView.animate(withDuration: 0.3)  { self.introduceLabel.transform = CGAffineTransform.identity }
        })
    }
    
    @objc func introduceLabelStay() {
        if stayFlag {
            UIView.animate(withDuration: 1, animations: {
                self.introduceLabel.alpha = 0.0
            }) { _ in
                self.timer.invalidate()
                self.stayFlag = false
            }
        } else {
            stayFlag = true
        }
    }
}

extension SceneViewController: ARSCNViewDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if placeFlag {
            self.introduceLabel.alpha = 0.0
            
            placeFlag = false
            mySpaceNode.scale = SCNVector3Make(0.05, 0.05, 0.05)
            sceneView.scene.rootNode.addChildNode(mySpaceNode)
            
            self.startCountDownTimer()
        }
    }
    
    func startCountDownTimer() {
        cardView.backgroundColor = UIColor.white
        cardView.alpha = 0.9
        cardView.layer.cornerRadius = 30
        
        countDownlabel.frame = CGRect(x: 150, y: 200, width: 150, height: 15)
        countDownlabel.text = "\(secondsToCountDown)"
        countDownlabel.adjustsFontSizeToFitWidth = true
        countDownlabel.minimumScaleFactor = 0.3
        countDownlabel.textColor = #colorLiteral(red: 0.07843137255, green: 0.262745098, blue: 0.4862745098, alpha: 1)
        countDownlabel.textAlignment = .center
        countDownlabel.font = UIFont.boldSystemFont(ofSize: 75)
        cardView.addSubview(countDownlabel)
        
        gameRuleLabel.text = "GAME RULE: Find The Law\nplease find the rules of the numbers given,\nand then fill in the blank."
        gameRuleLabel.textAlignment = .center
        gameRuleLabel.textColor = #colorLiteral(red: 0.07843137255, green: 0.262745098, blue: 0.4862745098, alpha: 0.9)
        gameRuleLabel.numberOfLines = 0
        gameRuleLabel.font = UIFont(name: "Avenir", size: 22)?.bold()
        gameRuleLabel.layer.cornerRadius = 20
        gameRuleLabel.clipsToBounds = true
        
        cardView.addSubview(gameRuleLabel)
        
        self.view.addSubview(cardView)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        countDownlabel.translatesAutoresizingMaskIntoConstraints = false
        gameRuleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: introduceLabel.centerXAnchor),
            cardView.centerYAnchor.constraint(equalTo: introduceLabel.centerYAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 350),
            cardView.heightAnchor.constraint(equalToConstant: 350),
            
            countDownlabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 120),
            countDownlabel.rightAnchor.constraint(equalTo: cardView.rightAnchor, constant: -120),
            countDownlabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 40),
            countDownlabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -220),
            
            gameRuleLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            gameRuleLabel.topAnchor.constraint(equalTo: countDownlabel.bottomAnchor, constant: -10),
            gameRuleLabel.widthAnchor.constraint(equalToConstant: 300),
            gameRuleLabel.heightAnchor.constraint(equalToConstant: 220),
            
            ])
        
        startTimer()
    }
    
    func startTimer() {
        currentNumber = secondsToCountDown + 1
        countDownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decreaseNumber), userInfo: nil, repeats: true)
        countDownTimer.fire()
    }
    
    @objc func decreaseNumber() {
        currentNumber -= 1
        countDownlabel.text = String(currentNumber)
    }
    
    func timesUp() {
        countDownTimer.invalidate()
        UIView.animate(withDuration: 1, animations: {
            self.cardView.alpha = 0.0
        }) { _ in
            self.gameView.backgroundColor = UIColor.white
            self.gameView.alpha = 0.9
            self.gameView.translatesAutoresizingMaskIntoConstraints = false
            self.gameView.layer.cornerRadius = 20
            self.gameView.clipsToBounds = true
            self.view.addSubview(self.gameView)
            
            self.gameTitleLabel.font = UIFont(name: "Avenir", size: 24)?.bold()
            self.gameTitleLabel.text = "FIND THE LAW"
            self.gameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.gameTitleLabel.textColor = #colorLiteral(red: 0.07843137255, green: 0.262745098, blue: 0.4862745098, alpha: 1)
            self.gameTitleLabel.textAlignment = .center
            self.gameView.addSubview(self.gameTitleLabel)
            
            self.nextButton.setTitle("Space  >", for: .normal)
            self.nextButton.tintColor = #colorLiteral(red: 0.07843137255, green: 0.262745098, blue: 0.4862745098, alpha: 1)
            self.nextButton.setTitleColor(#colorLiteral(red: 0.07843137255, green: 0.262745098, blue: 0.4862745098, alpha: 1), for: .normal)
            self.nextButton.backgroundColor = UIColor(white: 1, alpha: 1)
            self.nextButton.alpha = 0.9
            self.view.addSubview(self.nextButton)
            
            self.questionCards.append(self.questionCard1)
            self.questionCards.append(self.questionCard2)
            self.questionCards.append(self.questionCard3)
            self.questionCards.append(self.questionCard4)
            self.questionCards.append(self.questionCard5)
            self.questionCards.append(self.questionCard6)
            
            self.answerCards.append(self.answerCard1)
            self.answerCards.append(self.answerCard2)
            self.answerCards.append(self.answerCard3)
            self.answerCards.append(self.answerCard4)
            
            for questionCard in self.questionCards {
                questionCard.translatesAutoresizingMaskIntoConstraints = false
                questionCard.backgroundColor = #colorLiteral(red: 0.7294117647, green: 0.8862745098, blue: 0.9215686275, alpha: 1)
                questionCard.layer.cornerRadius = 10
                questionCard.clipsToBounds = true
                questionCard.textAlignment = .center
                questionCard.textColor = #colorLiteral(red: 0.231372549, green: 0.5803921569, blue: 0.7098039216, alpha: 1)
                questionCard.font = UIFont(name: "Avenir", size: 20)?.bold()
                self.questionStackView.addSubview(questionCard)
            }
            
            for answerCrad in self.answerCards {
                answerCrad.translatesAutoresizingMaskIntoConstraints = false
                answerCrad.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.7882352941, blue: 0.831372549, alpha: 1)
                answerCrad.layer.cornerRadius = 10
                answerCrad.clipsToBounds = true
                answerCrad.titleLabel?.textAlignment = .center
                answerCrad.setTitleColor(#colorLiteral(red: 0.7411764706, green: 0.3529411765, blue: 0.4823529412, alpha: 1), for: .normal)
                answerCrad.titleLabel?.font = UIFont(name: "Avenir", size: 30)?.bold()
                self.answerStackView.addSubview(answerCrad)
                answerCrad.addTarget(self, action: #selector(self.checkAnswer(sender:)), for: .touchUpInside)
            }
            
            self.questionStackView.backgroundColor = .clear
            self.answerStackView.backgroundColor = .clear
            
            self.questionStackView.translatesAutoresizingMaskIntoConstraints = false
            self.answerStackView.translatesAutoresizingMaskIntoConstraints = false
            
            self.gameView.addSubview(self.questionStackView)
            self.gameView.addSubview(self.answerStackView)
            
            self.view.addSubview(self.timeLabel)
            self.view.addSubview(self.distanceLabel)
            
            NSLayoutConstraint.activate([
                self.nextButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -30),
                self.nextButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30),
                self.nextButton.widthAnchor.constraint(equalToConstant: 125),
                self.nextButton.heightAnchor.constraint(equalToConstant: 60),
                
                self.gameView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.gameView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                self.gameView.widthAnchor.constraint(equalToConstant: 280),
                self.gameView.heightAnchor.constraint(equalToConstant: 390),
                
                self.timeLabel.leftAnchor.constraint(equalTo: self.gameView.leftAnchor),
                self.timeLabel.bottomAnchor.constraint(equalTo: self.gameView.topAnchor, constant: -20),
                self.timeLabel.widthAnchor.constraint(equalToConstant: 120),
                self.timeLabel.heightAnchor.constraint(equalToConstant: 45),
                
                self.distanceLabel.rightAnchor.constraint(equalTo: self.gameView.rightAnchor),
                self.distanceLabel.bottomAnchor.constraint(equalTo: self.gameView.topAnchor, constant: -20),
                self.distanceLabel.widthAnchor.constraint(equalToConstant: 150),
                self.distanceLabel.heightAnchor.constraint(equalToConstant: 45),
                
                self.gameTitleLabel.topAnchor.constraint(equalTo: self.gameView.topAnchor, constant: 25),
                self.gameTitleLabel.centerXAnchor.constraint(equalTo: self.gameView.centerXAnchor),
                self.gameTitleLabel.heightAnchor.constraint(equalToConstant: 20),
                
                self.questionStackView.centerXAnchor.constraint(equalTo: self.gameView.centerXAnchor),
                self.questionStackView.topAnchor.constraint(equalTo: self.gameView.topAnchor, constant: 70),
                self.questionStackView.widthAnchor.constraint(equalToConstant: 170),
                self.questionStackView.heightAnchor.constraint(equalToConstant: 110),
                
                self.answerStackView.centerXAnchor.constraint(equalTo: self.gameView.centerXAnchor),
                self.answerStackView.topAnchor.constraint(equalTo: self.gameView.topAnchor, constant: 195),
                self.answerStackView.widthAnchor.constraint(equalToConstant: 170),
                self.answerStackView.heightAnchor.constraint(equalToConstant: 170),
                
                self.questionCard1.topAnchor.constraint(equalTo: self.questionStackView.topAnchor),
                self.questionCard1.leftAnchor.constraint(equalTo: self.questionStackView.leftAnchor),
                self.questionCard1.heightAnchor.constraint(equalToConstant: 50),
                self.questionCard1.widthAnchor.constraint(equalToConstant: 50),
                
                self.questionCard2.topAnchor.constraint(equalTo: self.questionStackView.topAnchor),
                self.questionCard2.centerXAnchor.constraint(equalTo: self.questionStackView.centerXAnchor),
                self.questionCard2.heightAnchor.constraint(equalToConstant: 50),
                self.questionCard2.widthAnchor.constraint(equalToConstant: 50),
                
                self.questionCard3.topAnchor.constraint(equalTo: self.questionStackView.topAnchor),
                self.questionCard3.rightAnchor.constraint(equalTo: self.questionStackView.rightAnchor),
                self.questionCard3.heightAnchor.constraint(equalToConstant: 50),
                self.questionCard3.widthAnchor.constraint(equalToConstant: 50),
                
                self.questionCard4.bottomAnchor.constraint(equalTo: self.questionStackView.bottomAnchor),
                self.questionCard4.leftAnchor.constraint(equalTo: self.questionStackView.leftAnchor),
                self.questionCard4.heightAnchor.constraint(equalToConstant: 50),
                self.questionCard4.widthAnchor.constraint(equalToConstant: 50),
                
                self.questionCard5.bottomAnchor.constraint(equalTo: self.questionStackView.bottomAnchor),
                self.questionCard5.centerXAnchor.constraint(equalTo: self.questionStackView.centerXAnchor),
                self.questionCard5.heightAnchor.constraint(equalToConstant: 50),
                self.questionCard5.widthAnchor.constraint(equalToConstant: 50),
                
                self.questionCard6.bottomAnchor.constraint(equalTo: self.questionStackView.bottomAnchor),
                self.questionCard6.rightAnchor.constraint(equalTo: self.questionStackView.rightAnchor),
                self.questionCard6.heightAnchor.constraint(equalToConstant: 50),
                self.questionCard6.widthAnchor.constraint(equalToConstant: 50),
                
                self.answerCard1.topAnchor.constraint(equalTo: self.answerStackView.topAnchor),
                self.answerCard1.leftAnchor.constraint(equalTo: self.answerStackView.leftAnchor),
                self.answerCard1.widthAnchor.constraint(equalToConstant: 80),
                self.answerCard1.heightAnchor.constraint(equalToConstant: 80),
                
                self.answerCard2.topAnchor.constraint(equalTo: self.answerStackView.topAnchor),
                self.answerCard2.rightAnchor.constraint(equalTo: self.answerStackView.rightAnchor),
                self.answerCard2.widthAnchor.constraint(equalToConstant: 80),
                self.answerCard2.heightAnchor.constraint(equalToConstant: 80),
                
                self.answerCard3.bottomAnchor.constraint(equalTo: self.answerStackView.bottomAnchor),
                self.answerCard3.leftAnchor.constraint(equalTo: self.answerStackView.leftAnchor),
                self.answerCard3.widthAnchor.constraint(equalToConstant: 80),
                self.answerCard3.heightAnchor.constraint(equalToConstant: 80),
                
                self.answerCard4.bottomAnchor.constraint(equalTo: self.answerStackView.bottomAnchor),
                self.answerCard4.rightAnchor.constraint(equalTo: self.answerStackView.rightAnchor),
                self.answerCard4.widthAnchor.constraint(equalToConstant: 80),
                self.answerCard4.heightAnchor.constraint(equalToConstant: 80),
                
                ])
            self.currentTimeLeft = self.timeLeft + 0.1
            self.currentDistanceLeft = self.distanceLeft + 10
            self.gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.gameTimeCountDown), userInfo: nil, repeats: true)
            self.mySpaceNode.childNodes.filter({$0.name == "earthNode" || $0.name == "propellerNode"}).forEach({
                if $0.name == "earthNode" {
                    $0.runAction(SCNAction.move(to: SCNVector3(x: 0, y: 1.67, z: -4), duration: self.timeLeft), forKey: "startMove")
                } else {
                    $0.runAction(SCNAction.move(to: SCNVector3(x: 0, y: 1.82, z: -3.8), duration: self.timeLeft), forKey: "startMove")
                }
            })
            self.gameTimer.fire()
            self.setupGameView()
        }
    }
    
    func setupGameView() {
        
        if gameDifficulty == 1 {
            question = generateQuestion(for: "easy")
        } else if gameDifficulty == 2 {
            question = generateQuestion(for: "Fibonacci")
        } else {
            question = generateQuestion(for: "difficult")
        }
        
        answerNumber = 6.arc4random
        answer = question[answerNumber]
        
        for i in 0...5 {
            questionCards[i].text = String(question[i])
            if i == answerNumber {
                questionCards[i].text = "?"
            }
        }
        
        let fakeAnswer = generateFakeAnswer(for: answer)
        
        for i in 0...3 {
            answerCards[i].setTitle(String(fakeAnswer[i]), for: .normal)
        }
        answerCards[4.arc4random].setTitle(String(answer), for: .normal)
    }
    
    @objc func gameTimeCountDown() {
        currentTimeLeft -= 0.1
        currentDistanceLeft -= 10
        timeLabel.text = "Time: " + String(format: "%.1fs", currentTimeLeft)
        if currentTimeLeft == -0.0 {
            timeLabel.text = "Time: 0.0s"
        }
        distanceLabel.text = "Distance: \(currentDistanceLeft)km"
    }
    
    @objc func checkAnswer(sender: UIButton) {
        questionCards[answerNumber].text = sender.titleLabel?.text
        if sender.titleLabel?.text == String(answer) {
            questionSolved += 1
            UIView.animate(withDuration: 0.3, animations: {
                self.gameView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.gameView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.gameView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.gameView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        }, completion: { _ in
                            self.currentTimeLeft += 6
                            self.currentDistanceLeft += 600
                            self.mySpaceNode.childNodes.filter({$0.name == "earthNode" || $0.name == "propellerNode"}).forEach({
                                if $0.actionKeys.contains("startMove") {
                                    $0.removeAction(forKey: "startMove")
                                }
                                if $0.name == "earthNode" {
                                    $0.position = SCNVector3(x: 0, y: $0.position.y + 0.465, z: -4)
                                    $0.runAction(SCNAction.move(to: SCNVector3(x: 0, y: 1.67, z: -4), duration: self.currentTimeLeft), forKey: "startMove")
                                } else {
                                    $0.position = SCNVector3(x: 0, y: $0.position.y + 0.465, z: -3.8)
                                    $0.runAction(SCNAction.move(to: SCNVector3(x: 0, y: 1.82, z: -3.8), duration: self.currentTimeLeft), forKey: "startMove")
                                }
                            })
                            self.setupGameView()
                        })
                    })
                })
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.gameView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }) { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.gameView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.gameView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.3, animations: {
                            self.gameView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                        }, completion: { _ in
                            self.questionCards[self.answerNumber].text = "?"
                            self.currentTimeLeft -= 3
                            self.currentDistanceLeft -= 300
                            self.mySpaceNode.childNodes.filter({$0.name == "earthNode" || $0.name == "propellerNode"}).forEach({
                                if $0.actionKeys.contains("startMove") {
                                    $0.removeAction(forKey: "startMove")
                                }
                                if $0.name == "earthNode" {
                                    $0.position = SCNVector3(x: 0, y: $0.position.y - 0.24, z: -4)
                                    $0.runAction(SCNAction.move(to: SCNVector3(x: 0, y: 1.67, z: -4), duration: self.currentTimeLeft), forKey: "startMove")
                                } else {
                                    $0.position = SCNVector3(x: 0, y: $0.position.y - 0.24, z: -3.8)
                                    $0.runAction(SCNAction.move(to: SCNVector3(x: 0, y: 1.82, z: -3.8), duration: self.currentTimeLeft), forKey: "startMove")
                                }
                            })
                        })
                    })
                })
            }
        }
    }
    
    func gameOver() {
        self.mySpaceNode.childNodes.filter({$0.name == "earthNode" || $0.name == "propellerNode"}).forEach({
            if $0.actionKeys.contains("startMove") {
                $0.removeAction(forKey: "startMove")
            }
        })
        gameTimer.invalidate()
        
        for answerCard in answerCards {
            answerCard.isEnabled = false
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.gameView.alpha = 0.0
            self.nextButton.alpha = 0.0
            self.timeLabel.alpha = 0.0
            self.distanceLabel.alpha = 0.0
        }) { _ in
            do {
                self.resultMusicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "fireBurn", ofType: "wav")!))
                self.resultMusicPlayer.prepareToPlay()
            } catch {
                print(error.localizedDescription)
            }
            self.resultMusicPlayer.numberOfLoops = -1
            self.resultMusicPlayer.volume = 2.5
            self.resultMusicPlayer.play()
            
            self.mySpaceNode.childNodes.filter({$0.name == "earthNode" || $0.name == "propellerNode"}).forEach({
                $0.runAction(SCNAction.fadeOpacity(to: 0, duration: 3))
            })
            
            self.mySpaceNode.childNodes.filter({$0.name == "sunNode"}).forEach({
                $0.particleSystems?.first?.birthRate = 15000
                $0.runAction(SCNAction.scale(to: 3, duration: 5))
            })
        }
        
        resultImageView.image = UIImage(named: "fail")
        resultImageView.alpha = 0.9
        resultImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(resultImageView)
        
        self.view.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            resultImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            resultImageView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            resultImageView.widthAnchor.constraint(equalToConstant: 250),
            resultImageView.heightAnchor.constraint(equalToConstant: 250),
            
            retryButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80),
            retryButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 40),
            retryButton.heightAnchor.constraint(equalToConstant: 40),
            
            ])
        
        UIView.animate(withDuration: 0.3, animations: {
            self.resultImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.resultImageView.transform = .identity
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.resultImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.resultImageView.transform = .identity
                    })
                })
            })
        }
        
    }
    
    func success() {
        self.mySpaceNode.childNodes.filter({$0.name == "earthNode" || $0.name == "propellerNode"}).forEach({
            if $0.actionKeys.contains("startMove") {
                $0.removeAction(forKey: "startMove")
            }
        })
        gameTimer.invalidate()
        fireworkBackgroundView.backgroundColor = .black
        fireworkBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(fireworkBackgroundView)
        self.view.bringSubviewToFront(fireworkBackgroundView)
        
        resultImageView.image = UIImage(named: "succeed")
        resultImageView.alpha = 0.9
        
        self.fireworkBackgroundView.addSubview(resultImageView)
        resultImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.fireworkBackgroundView.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            fireworkBackgroundView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            fireworkBackgroundView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            fireworkBackgroundView.topAnchor.constraint(equalTo: self.view.topAnchor),
            fireworkBackgroundView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            fireworkBackgroundView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            fireworkBackgroundView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            resultImageView.centerXAnchor.constraint(equalTo: fireworkBackgroundView.centerXAnchor),
            resultImageView.centerYAnchor.constraint(equalTo: fireworkBackgroundView.centerYAnchor, constant: 20),
            resultImageView.widthAnchor.constraint(equalToConstant: 250),
            resultImageView.heightAnchor.constraint(equalToConstant: 250),
            
            retryButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -80),
            retryButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            retryButton.widthAnchor.constraint(equalToConstant: 40),
            retryButton.heightAnchor.constraint(equalToConstant: 40),
            
            ])
        
        UIView.animate(withDuration: 0.3, animations: {
            self.resultImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            UIView.animate(withDuration: 0.3, animations: {
                self.resultImageView.transform = .identity
            }, completion: { _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.resultImageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                }, completion: { _ in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.resultImageView.transform = .identity
                    })
                })
            })
        }
        
        createFirework()
        
        for answerCard in answerCards {
            answerCard.isEnabled = false
        }
        
        do {
            resultMusicPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "firework", ofType: "mp3")!))
            resultMusicPlayer.prepareToPlay()
        } catch {
            print(error.localizedDescription)
        }
        resultMusicPlayer.numberOfLoops = -1
        resultMusicPlayer.volume = 2.5
        resultMusicPlayer.play()
        
    }
    
    @objc func retry() {
        resultImageView.removeFromSuperview()
        if self.view.subviews.contains(fireworkBackgroundView) {
            fireworkBackgroundView.removeFromSuperview()
        } else {
            self.mySpaceNode.childNodes.filter({$0.name == "sunNode"}).forEach({
                $0.particleSystems?.first?.birthRate = 1500
                $0.runAction(SCNAction.scale(to: 0.9, duration: 0.1))
            })
        }
        
        if self.view.subviews.contains(retryButton) {
            retryButton.removeFromSuperview()
        }
        
        self.resultMusicPlayer.stop()
        
        self.mySpaceNode.childNodes.filter({$0.name == "earthNode" || $0.name == "propellerNode"}).forEach({
            $0.opacity = 1.0
            if $0.name == "earthNode" {
                $0.position = SCNVector3(x: 0, y: 3.5, z: -4)
            } else {
                $0.position = SCNVector3(x: 0, y: 3.65, z: -3.8)
            }
        })
        
        for answerCard in answerCards {
            answerCard.isEnabled = true
        }
        self.gameView.alpha = 0.9
        self.nextButton.alpha = 0.9
        self.timeLabel.alpha = 0.9
        self.distanceLabel.alpha = 0.9
        
        self.currentTimeLeft = self.timeLeft + 0.1
        self.currentDistanceLeft = self.distanceLeft + 10
        self.gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.gameTimeCountDown), userInfo: nil, repeats: true)
        self.mySpaceNode.childNodes.filter({$0.name == "earthNode" || $0.name == "propellerNode"}).forEach({
            if $0.name == "earthNode" {
                $0.runAction(SCNAction.move(to: SCNVector3(x: 0, y: 1.67, z: -4), duration: self.timeLeft), forKey: "startMove")
            } else {
                $0.runAction(SCNAction.move(to: SCNVector3(x: 0, y: 1.82, z: -3.8), duration: self.timeLeft), forKey: "startMove")
            }
        })
        self.gameTimer.fire()
        self.setupGameView()
        self.retryButton.removeFromSuperview()
    }
    
    public func createFirework() {
        
        let emitter = CAEmitterLayer()
        
        emitter.emitterPosition = CGPoint(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height)
        
        emitter.emitterSize = CGSize(width: 50, height: 0.0)
        
        emitter.emitterMode = CAEmitterLayerEmitterMode.outline
        
        emitter.emitterShape = CAEmitterLayerEmitterShape.line
        
        emitter.renderMode = CAEmitterLayerRenderMode.additive
        
        let bullet = CAEmitterCell()
        
        bullet.birthRate = 4.0
        
        bullet.lifetime = 1.3
        
        bullet.contents = self.imageWithColor(UIColor.white).cgImage
        
        bullet.emissionRange = 0.15 * CGFloat(Double.pi)
        
        bullet.velocity = self.view.bounds.size.height - 100
        
        bullet.velocityRange = 10
        
        bullet.yAcceleration = 0
        
        bullet.spin = CGFloat(Double.pi)
        
        bullet.redRange = 1.0
        bullet.greenRange = 1.0
        bullet.blueRange = 1.0
        
        let burst = CAEmitterCell()
        
        burst.birthRate = 1.0
        burst.velocity = 0
        burst.scale = 2.5
        burst.redSpeed = -1.5
        burst.blueSpeed = 1.5
        burst.greenSpeed = 1.0
        burst.lifetime = 0.35
        
        let spark = CAEmitterCell()
        
        spark.birthRate = 666
        spark.lifetime = 3
        spark.velocity = 125
        spark.velocityRange = 100
        spark.emissionRange = 2 * CGFloat(Double.pi)
        
        spark.contents = UIImage(named: "fire.png")?.cgImage
        spark.scale = 0.1
        spark.scaleRange = 0.05
        
        spark.greenSpeed = -0.1
        spark.redSpeed = 0.4
        spark.blueSpeed = -0.1
        spark.alphaSpeed = -0.5
        spark.spin = 2 * CGFloat(Double.pi)
        spark.spinRange = 2 * CGFloat(Double.pi)
        
        emitter.emitterCells = [bullet]
        
        bullet.emitterCells = [burst]
        
        burst.emitterCells = [spark]
        
        self.fireworkBackgroundView.layer.addSublayer(emitter)
        
    }
    
    func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 5.0, height: 5.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
}

extension UIFont {
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}

extension SceneViewController {
    func generateQuestion(for level: String) -> [Int] {
        var answer = [Int]()
        if level == "easy" {
            let randomNumber1 = 12.arc4random
            let randomNumber2 = 12.arc4random
            let randomNumber3 = 12.arc4random
            answer.append(randomNumber1)
            let difference = randomNumber3 - randomNumber2
            for i in 1...5 {
                answer.append(answer[i - 1] + difference)
            }
            return answer
        } else if level == "Fibonacci" {
            let randomNumber1 = 12.arc4random
            let randomNumber2 = 12.arc4random
            answer.append(randomNumber1)
            answer.append(randomNumber2)
            for i in 2...5 {
                answer.append(answer[i - 1] + answer[i - 2])
            }
            return answer
        } else if level == "difficult" {
            let randomNumber1 = 4.arc4random
            answer.append(randomNumber1)
            let difference1 = Int.random(in: 2...3)
            let difference2 = Int.random(in: 2...10)
            for i in 1...5 {
                answer.append(answer[i - 1] * difference1 + difference2)
            }
            return answer
        }
        return [9, 9, 9, 9, 9, 9]
    }
    
    func generateFakeAnswer(for answer: Int) -> [Int] {
        var fake = [Int]()
        let randomNumber1 = Int.random(in: (answer - 5)..<answer)
        let randomNumber2 = Int.random(in: (answer + 1)...(answer + 5))
        let randomNumber3 = Int.random(in: (answer - 10)..<(answer - 5))
        let randomMunber4 = Int.random(in: (answer + 6)...(answer + 10))
        
        fake.append(randomNumber1)
        fake.append(randomNumber2)
        fake.append(randomNumber3)
        fake.append(randomMunber4)
        
        return fake
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
