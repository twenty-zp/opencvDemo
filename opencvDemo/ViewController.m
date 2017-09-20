//
//  ViewController.m
//  opencvDemo
//
//  Created by zp on 2017/8/28.
//  Copyright © 2017年 ilogie. All rights reserved.
//


#import "ViewController.h"
#import "VideoCamera.h"
#import <opencv2/core.hpp>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/imgproc.hpp>

#import "BusinessCardDetector.h"
#import "BusinessCard.hpp"
#import "MaskLayer.h"
const double DETECT_RESIZE_FACTOR = 0.5;

@interface ViewController ()<CvVideoCameraDelegate>
{
    BusinessCardDetector *businessCardDetector;
    std::vector<BusinessCard> detectedBusinessCards;
    CGFloat height;
    CGFloat width;
    NSMutableArray * array;
}
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (nonatomic,strong)MaskLayer *bordermask;
@property VideoCamera *videoCamera;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    array = [NSMutableArray array];
     height = [UIScreen mainScreen].bounds.size.height;
     width = [UIScreen mainScreen].bounds.size.width;
    businessCardDetector = new BusinessCardDetector();
    self.videoCamera = [[VideoCamera alloc] initWithParentView:self.backgroundView];
    self.videoCamera.delegate = self;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetHigh;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.letterboxPreview = YES;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    
    self.bordermask.frame = self.backgroundView.bounds;
    [self.view.layer addSublayer:self.bordermask];

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortraitUpsideDown:
            self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationLandscapeRight:
            self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        default:
            self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    
    [self refresh];
}
- (void)refresh {
    // Start or restart the video.
    [self.videoCamera stop];
    [self.videoCamera start];
}

- (void)processImage:(cv::Mat &)mat {

    switch (self.videoCamera.defaultAVCaptureVideoOrientation) {
        case AVCaptureVideoOrientationLandscapeLeft:
        case AVCaptureVideoOrientationLandscapeRight:
            // The landscape video is captured upside-down.
            // Rotate it by 180 degrees.
            cv::flip(mat, mat, -1);
            break;
        default:
            break;
    }
    // Detect businessCardDetector
    businessCardDetector->detect(mat, detectedBusinessCards,DETECT_RESIZE_FACTOR, true);

    if(detectedBusinessCards.size()> 0) {
        BusinessCard b = detectedBusinessCards[0];
        
        CGPoint centerPoint = CGPointMake(businessCardDetector->getCenterX()*1.0/mat.cols*width,businessCardDetector->getCenterY()*1.0/mat.rows*height);

        float point1x = businessCardDetector->temp[0].x*1.0/mat.cols*width;
        float point1y = businessCardDetector->temp[0].y*1.0/mat.rows*height;
        CGPoint point1   = {point1x,point1y};

        float point2x = businessCardDetector->temp[1].x*1.0/mat.cols*width;
        float point2y = businessCardDetector->temp[1].y*1.0/mat.rows*height;
        CGPoint point2  = {point2x,point2y};

        float point3x = businessCardDetector->temp[2].x*1.0/mat.cols*width;
        float point3y = businessCardDetector->temp[2].y*1.0/mat.rows*height;
        CGPoint point3  = {point3x,point3y};

        float point4x =  businessCardDetector->temp[3].x*1.0/mat.cols*width;
        float point4y =  businessCardDetector->temp[3].y*1.0/mat.rows*height;
        CGPoint point4  = {point4x,point4y};

        //         self.bordermask.lb  self.bordermask.lt self.bordermask.rt self.bordermask.rb
        NSArray * array = @[NSStringFromCGPoint(point1),
                            NSStringFromCGPoint(point2),
                            NSStringFromCGPoint(point3),
                            NSStringFromCGPoint(point4)];
        
        for (NSString * pointStr in array) {
            CGPoint point = CGPointFromString(pointStr);
            CGFloat widthOffset = point.x - centerPoint.x;
            CGFloat heightOffset = point.y - centerPoint.y;
            if (widthOffset > 0.0) {
                if (heightOffset > 0.0) {
                    self.bordermask.rb = point;
                }else
                {
                    self.bordermask.rt = point;
                }
            }else
            {
                if (heightOffset > 0.0) {
                    
                    self.bordermask.lb = point;
                }else
                {
                   
                    self.bordermask.lt = point;
                }
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bordermask startDraw];
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.bordermask stopDraw];
        });
    }
}


- (MaskLayer *)bordermask
{
    if (!_bordermask) {
        MaskLayer * mask = [MaskLayer layer];
        _bordermask = mask;
    }
    return _bordermask;
}
@end
