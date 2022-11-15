//
//  HourlyUnit.m
//  Weather-app
//
//  Created by Reve on 11/14/22.
//

#import "HourlyUnit.h"

@implementation HourlyUnit

-(nullable instancetype) initWithDictionary:(nullable NSDictionary*) dict {
    if(self = [super init]) {
        self.time = dict[@"time"];
        self.temperature_2m = dict[@"temperature_2m"];
    }
    return self;
}
@end
