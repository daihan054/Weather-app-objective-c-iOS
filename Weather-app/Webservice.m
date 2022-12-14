//
//  Webservice.m
//  Weather-app
//
//  Created by Reve on 11/12/22.
//

#import "Webservice.h"

static NSString *baseURL;
static NSString *todaysWeather;
static NSString *hourlyWeather;
static NSString *dailtyWeather;

@implementation Webservice

+(instancetype) sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t once_token;
    
    dispatch_once(&once_token,^{
        sharedInstance = [[self alloc]init];
    });
    
    return sharedInstance;
}

-(instancetype) init {
    self = [super init];
    [self setAllApiURL];
    return self;
}

-(void) setAllApiURL {
    baseURL = @"https://api.open-meteo.com/v1/forecast";
    todaysWeather = [NSString stringWithFormat:@"%@?daily=temperature_2m_min,temperature_2m_max&current_weather=true&hourly=temperature_2m&timezone=GMT",baseURL];
}

-(void)basicHTTPGetApiURL:(NSString*_Nullable)url header:(NSDictionary*)headerDict body:(NSData*)bodyData completionHandler:(void (^_Nullable)(NSDictionary* responseDictionary, bool resultFound))completionBlock {
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:120.0];
    
    [urlRequest setHTTPMethod:@"GET"];
    
    if(headerDict) {
        [urlRequest setAllHTTPHeaderFields:headerDict];
    }
    
    if(bodyData){
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [urlRequest setHTTPBody:bodyData];
    }
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:Nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if(httpResponse.statusCode == 200 && data != nil) {
            NSError *parseError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            completionBlock(responseDictionary,true);
        } else {
            completionBlock(nil,true);
        }
    }];
    [dataTask resume];
}

-(void) fetchTodaysWeatherDataWithLatitude:(double)latitude longitude:(double)longitude completionBlock:(nullable void (^)(NSDictionary* _Nullable)) completionBlock {
    todaysWeather = [todaysWeather stringByAppendingString: [NSString stringWithFormat:@"&latitude=%f&longitude=%f",latitude,longitude]];
    
    NSLog(@"latitude=%f longitude=%f",latitude,longitude);
    [self basicHTTPGetApiURL:todaysWeather header:nil body:nil completionHandler:^(NSDictionary* responseDictionary, bool resultFound) {
        if(resultFound) {
            completionBlock(responseDictionary);
        } else {
            completionBlock(nil);
        }
    }];
}

@end
