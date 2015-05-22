//
//  ViewController.m
//  facedetect

#import "ViewController.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/objdetect.hpp>

@interface ViewController ()
{
    UIImageView *imageView;
    cv::CascadeClassifier cascade;
    std::vector<cv::Rect> objects;
}

@end

@implementation ViewController

- (void)processImage:(cv::Mat &)image {
    cv::Mat grayMat;
    cv::cvtColor(image, grayMat, CV_BGR2GRAY);
    
    cv::equalizeHist(grayMat, grayMat);

    objects.clear();
    cascade.detectMultiScale(grayMat, objects,
                                 4.6, 1,
                                 CV_HAAR_SCALE_IMAGE,
                                 cv::Size(40, 40));
    
    for(size_t i = 0; i < objects.size(); ++i) {
        cv::Point center;
        int radius;
        const cv::Rect& r = objects[i];
        center.x = cv::saturate_cast<int>((r.x + r.width*0.5));
        center.y = cv::saturate_cast<int>((r.y + r.height*0.5));
        radius = cv::saturate_cast<int>((r.width + r.height)*0.25);
        cv::circle(image, center, radius, cv::Scalar(80,80,255), 3, 8, 0 );
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"haarcascade_frontalface_alt.xml"
                                                     ofType:nil];
    std::string cascade_path = (char *)[path UTF8String];
    if (!cascade.load(cascade_path)) {
        NSLog(@"Couldn't load haar cascade file.");
    }

    
    CGRect rect = [UIScreen mainScreen].bounds;
    imageView = [[UIImageView alloc]init];
    self.videoCamera = [[CvVideoCamera alloc]initWithParentView:imageView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetHigh;
    self.videoCamera.defaultFPS = 30;
    
    imageView.frame = rect;
    [self.view addSubview: imageView];
    [self.videoCamera start];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
