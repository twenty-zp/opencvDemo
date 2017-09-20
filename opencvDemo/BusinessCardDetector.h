//
//  BusinessCardDetector.hpp
//  opencvDemo
//
//  Created by zp on 2017/9/18.
//  Copyright © 2017年 ilogie. All rights reserved.
//

#ifndef BusinessCardDetector_hpp
#define BusinessCardDetector_hpp

#include <stdio.h>
#import "BusinessCard.hpp"
using namespace cv;
class BusinessCardDetector
{
public:
    void detect(cv::Mat &image, std::vector<BusinessCard> &businessCard, double resizeFactor = 1.0, bool draw = false);
    float getCenterX() const;
    float getCenterY() const;

    void setCenterX(float x1);
    void setCenterY(float y1);

    const cv::Mat &getMask() const;
    Point2f temp[4] ;
    std::vector<cv::Point> businessCardContor;
    
private:
    void createMask(const cv::Mat &image);
    bool verifySizes(RotatedRect mr,double factor);
    cv::Mat resizedImage;
    cv::Mat mask;
    cv::Mat edges;
    float x;
    float y;
    std::vector<std::vector<cv::Point>> contours;
    std::vector<cv::Vec4i> hierarchy;
};

#endif /* BusinessCardDetector_hpp */
