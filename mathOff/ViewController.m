//
//  ViewController.m
//  mathOff
//
//  Created by Andrew Dulle on 2/22/16.
//  Copyright © 2016 Andrew Dulle. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UILabel *numberOne;
@property (weak, nonatomic) IBOutlet UILabel *plus;
@property (weak, nonatomic) IBOutlet UILabel *numberTwo;
@property int firstNumber;
@property int secondNumber;
@property int answer;
@property (weak, nonatomic) IBOutlet UITextField *userAnswer;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UILabel *correct;
@property (weak, nonatomic) IBOutlet UILabel *incorrect;
@property int totalCorrectAnswers;
@property int totalIncorrectAnswers;
@property (weak, nonatomic) IBOutlet UILabel *streak;
@property int totalStreak;
@property int typeOfQuestion;
@property (weak, nonatomic) IBOutlet UILabel *highScoreLabel;
@property int theHighScore;
@property NSTimer *answerTimer;
@property (weak, nonatomic) IBOutlet UILabel *answerTimerLabel;
@property int seconds;
@end

@implementation ViewController


// Do any additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numberOne.hidden = YES;
    self.plus.hidden = YES;
    self.numberTwo.hidden = YES;
    self.userAnswer.hidden = YES;
    self.submit.hidden = YES;
    self.correct.hidden = YES;
    self.incorrect.hidden = YES;
    self.streak.hidden = YES;
    self.highScoreLabel.hidden = NO;
    self.answerTimerLabel.hidden = YES;
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // http://www.ios-blog.co.uk/tutorials/objective-c/storing-data-with-nsuserdefaults/
    
    self.theHighScore = (int)[defaults integerForKey:@"HighScore"];
    // http://www.ios-blog.co.uk/tutorials/objective-c/storing-data-with-nsuserdefaults/
    
    self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %d",self.theHighScore];
    // http://www.ios-blog.co.uk/tutorials/objective-c/storing-data-with-nsuserdefaults/

    
}


// Dispose of any resources that can be recreated.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

// User hits START Button
- (IBAction)startButtonWasTapped:(id)sender {

    [self askQuestion];

}


// User hits SUBMIT button
- (IBAction)submitButtonWasTapped:(id)sender {
    
    int userAnswerInt = [self.userAnswer.text intValue];
    
    [self.answerTimer invalidate];
    self.answerTimer = nil;
    
    // IF THE ANSWER IS CORRECT
    
    if (userAnswerInt == self.answer) {
    
        self.view.backgroundColor = [UIColor greenColor];
        
        self.userAnswer.text = nil;
        // http://stackoverflow.com/questions/1168680/best-way-to-clear-a-uitextfield
        
        self.totalCorrectAnswers +=1;
        
        self.correct.text = [NSString stringWithFormat:@"Right: %d",self.totalCorrectAnswers];
        
        self.totalStreak +=1;
        
        self.streak.hidden = NO;
        
        self.streak.text = [NSString stringWithFormat:@"Streak: %d",self.totalStreak];
        
        [self askQuestion];
        
    // IF THE ANSWER IS INCORRECT
    
    }else if (userAnswerInt != self.answer) {
        
        self.view.backgroundColor = [UIColor redColor];
        
        self.userAnswer.text = nil;
        // http://stackoverflow.com/questions/1168680/best-way-to-clear-a-uitextfield
        
        self.totalIncorrectAnswers +=1;
        
        self.incorrect.text = [NSString stringWithFormat:@"Wrong: %d",self.totalIncorrectAnswers];
        
        if (self.totalStreak > self.theHighScore) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setInteger:self.totalStreak forKey:@"HighScore"];
            
            [defaults synchronize];
            // http://www.ios-blog.co.uk/tutorials/objective-c/storing-data-with-nsuserdefaults/

        }
        
        self.totalStreak = 0;
        
        self.streak.hidden = YES;
        
        [self askQuestion];
        
    }
    
}

// QUESTION
- (void) askQuestion {
    
    
    [self.answerTimer invalidate];
    self.answerTimer = nil;
    

    self.seconds = 0;
    
    // NOT ON STREAK
    if (self.totalStreak < 10) {

        self.firstNumber = arc4random_uniform(10);
    
        self.secondNumber = arc4random_uniform(10);
    
        // http://stackoverflow.com/questions/160890/generating-random-numbers-in-objective-c
    
    }else if (self.totalStreak >= 10) {
    
    // ON STREAK
        self.streak.textColor = [UIColor orangeColor];
        
        self.firstNumber = arc4random_uniform(20);
        
        self.secondNumber = arc4random_uniform(20);
        
    }
    
// ADDITION, SUBTRACTION AND MULTIPLICATION
    self.typeOfQuestion = arc4random_uniform(3);
    
    if (self.typeOfQuestion == 0) {
        
        self.answer = self.firstNumber + self.secondNumber;
        
        self.plus.text = @"+";
        
    }else if (self.typeOfQuestion == 1) {
        
        self.answer = self.firstNumber - self.secondNumber;
        
        self.plus.text = @"-";
        
    }else if (self.typeOfQuestion == 2) {
        
        self.answer = self.firstNumber * self.secondNumber;
        
        self.plus.text = @"*";
        
    }
    
    self.numberOne.text = [NSString stringWithFormat:@"%d",self.firstNumber];
    
    self.numberTwo.text = [NSString stringWithFormat:@"%d",self.secondNumber];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.theHighScore = (int)[defaults integerForKey:@"HighScore"];
    
    self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %d",self.theHighScore];
    // http://www.ios-blog.co.uk/tutorials/objective-c/storing-data-with-nsuserdefaults/
    
    self.startButton.hidden = YES;
    self.numberOne.hidden = NO;
    self.plus.hidden = NO;
    self.numberTwo.hidden = NO;
    self.userAnswer.hidden = NO;
    self.submit.hidden = NO;
    self.correct.hidden = NO;
    self.incorrect.hidden = NO;
    self.highScoreLabel.hidden = NO;
    self.answerTimerLabel.hidden = NO;
    
    self.answerTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0
    target: self
    selector:@selector(addSecond)
    userInfo: nil
    repeats:YES];
    
    
}

- (void) addSecond {
    
        self.seconds += 1;
    
    // IF TIME RUNS OUT
    
    if (self.seconds == 5) {
        
        self.view.backgroundColor = [UIColor redColor];
        
        self.userAnswer.text = nil;
        // http://stackoverflow.com/questions/1168680/best-way-to-clear-a-uitextfield
        
        self.totalIncorrectAnswers +=1;
        
        self.incorrect.text = [NSString stringWithFormat:@"Wrong: %d",self.totalIncorrectAnswers];
        
        if (self.totalStreak > self.theHighScore) {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setInteger:self.totalStreak forKey:@"HighScore"];
            
            [defaults synchronize];
            // http://www.ios-blog.co.uk/tutorials/objective-c/storing-data-with-nsuserdefaults/
            
        
            self.totalStreak = 0;
        
        }
        self.streak.hidden = YES;
        
        [self askQuestion];
        
    }
    
    self.answerTimerLabel.text = [NSString stringWithFormat:@"%d",self.seconds];
    
}



// first - need integer that's going to keep track of what second the user is on and subtract downward. next - if it hits zero, mark the question wrong and ask another question. When a question is asked, the timer needs to reset. If they get it right the timer needs to reset. User needs to see how much time they have. The code inside of addSecond is going to get called every second. addSecond needs to know what second it is on, so you need an int in the interface called second. It needs to add 1 every time addSecond is called. View controller knows what second it is on. Everytime a new question is called, time needs to be reset, so second int (self.second) needs to be set to 0. Then you need to have logic, where if second > 2, the question is incorrect.


@end