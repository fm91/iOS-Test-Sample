//
//  TableSectionTableViewCell.h
//  IOSProgrammerTest
//
//  Created by Justin LeClair on 12/15/14.
//  Copyright (c) 2014 AppPartner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatData.h"
@interface ChatCell : UITableViewCell
- (CGFloat)loadWithData:(ChatData *)chatData;
- (CGFloat)getTextMessageHeight:(NSString *)string;
- (CGFloat)getTextMessageWidth:(NSString *)string;
@end
