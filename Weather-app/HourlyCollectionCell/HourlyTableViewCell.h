//
//  HourlyTableViewCell.h
//  Weather-app
//
//  Created by Reve on 11/11/22.
//

#import <UIKit/UIKit.h>

@interface HourlyTableViewCell : UITableViewCell

@property(strong,atomic,class) NSString* identifier;

+(NSString* _Nullable) nib;
@end
