//
//  TableSectionTableViewCell.m
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell ()
@property (nonatomic, strong) IBOutlet UILabel *usernameLabel;
@property (nonatomic, strong) IBOutlet UITextView *messageTextView;

//I added this property to hold the avatar_icon
@property (weak, nonatomic) IBOutlet UIImageView *avatarIcon;

@end

@implementation ChatCell

- (void)awakeFromNib
{
    // Initialization code
}
// I've changed the return type of this method to save time later on. I can execute the code inside the method plus save the appropriate height of the custom cell. I've explained the steps in the following lines.
- (CGFloat)loadWithData:(ChatData *)chatData
{
    self.usernameLabel.text = chatData.username;
    self.messageTextView.text = chatData.message;
    
    //I've added the icon that is loaded from the url coming from the server
    [self.avatarIcon setImage: [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString: chatData.avatar_url]]]];
    
    //giving a circle shape to the imageview
    [self circleIcon: self.avatarIcon];
    
    
   //I'm calculating the height of the usernameLabel
    CGFloat usernameLableHeight = [self.usernameLabel intrinsicContentSize].height;
    
    // calculating the width of the UITextView (77 is the sum of horizontal spaces excluding the width of UITextView)
    CGFloat textWidth = self.frame.size.width - 109;
    NSLog(@"%f", textWidth);
    
     //Calculating the height of the UITextView inside the custom cell. For that I calculated an approximation of the area then devided it by the width
    CGFloat messageTextLableHeight = [self getTextMessageHeight:chatData.message] * [self getTextMessageWidth:chatData.message]/textWidth;
    
    //just displaying to see if I'm getting the results expected
    NSLog(@"%f, %f", usernameLableHeight, messageTextLableHeight);
   
    //then I return the appropriate height that allows to the content of the cell to be displayed completely
    CGFloat contentHeight = usernameLableHeight + messageTextLableHeight;
    
    //I noticed a few anomalies when the the height is under 42 so I'm treating that case separately.
    if (contentHeight < 50){
        //the imageView has 40x40, so the height has to be 40, plus 20 for the margins
         return 80;
      }
    //I return the value plus the top and bottom margins 10+10
    return contentHeight + 20.0;
}

#pragma mark -
#pragma mark - Added Methods

// the next two methods explained: the height of the custom cell has to change according to the content inside. To achieve that, I will calculate the area that the UITextvVew will have for each cell then devide it by the maximum width of the UItextView. I will need two methods:

//a method that calculates an approximate value of the height of a provided text (message) with the UIFont that we're using, but in this case it'll be the height of a single line of text.
- (CGFloat)getTextMessageHeight:(NSString *)string
{
    return [ string sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName: @"Machinato" size: 15]}].height;
}

//a method that calculates an approximate of the width of a provided text with the font that we're using
- (CGFloat)getTextMessageWidth:(NSString *)string
{
    NSLog(@"message: %@, %f", string, [string sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName: @"Machinato" size: 15]}].width);
    
    return [ string sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName: @"Machinato" size: 15]}].width;
}

-(void) circleIcon: (UIImageView *) image
{
    //giving a circle shape to the imageview
    image.layer.cornerRadius = 20;
    image.layer.masksToBounds = YES;
}

@end
