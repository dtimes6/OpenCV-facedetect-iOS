//
//  ViewController.h
//  facedetect
//

#import <UIKit/UIKit.h>
#import <opencv2/videoio/cap_ios.h>

@interface ViewController : UIViewController<CvVideoCameraDelegate>

@property (nonatomic,strong) CvVideoCamera *videoCamera;
@end

