//
//  BusinessCardDetector.cpp
//  opencvDemo
//
//  Created by zp on 2017/9/18.
//  Copyright © 2017年 ilogie. All rights reserved.
//

#include "BusinessCardDetector.h"
#include <opencv2/imgproc.hpp>

const double MASK_STD_DEVS_FROM_MEAN = 1.0;
const double MASK_EROSION_KERNEL_RELATIVE_SIZE_IN_IMAGE = 0.005;
const int MASK_NUM_EROSION_ITERATIONS = 8;

const double BLOB_RELATIVE_MIN_SIZE_IN_IMAGE = 0.05;

const cv::Scalar DRAW_RECT_COLOR(255, 0, 0); // Green

float BusinessCardDetector::getCenterX()const
{
    return  x;
}

float BusinessCardDetector::getCenterY()const
{
    return y;
}

void BusinessCardDetector::setCenterX(float x1)
{
    x = x1;
}

void BusinessCardDetector::setCenterY(float y1)
{
    y = y1;
}

void BusinessCardDetector::detect(cv::Mat &image, std::vector<BusinessCard> &businessCard, double resizeFactor, bool draw)
{
    //1.
    businessCard.clear();
    
    //2.
    cv::resize(image, resizedImage, cv::Size(), resizeFactor,resizeFactor, cv::INTER_AREA); //缩放比列

    //3.
    cv::GaussianBlur(resizedImage, resizedImage,cvSize(1, 1),0);
    
    //4.
    cv::cvtColor(resizedImage, resizedImage, CV_RGB2GRAY);
    
    //5.
    cv::Canny(resizedImage, edges, 130, 150);
    
    //6.
    cv::threshold(edges, edges, 0, 255, CV_THRESH_BINARY);
    
    //7.
    createMask(edges);
    
    //8.
    cv::findContours(mask, contours,cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);
    
    
    //9.
   this->temp[4] = {};
    for (std::vector<cv::Point> contour : contours) {
        RotatedRect rotatedRect = cv::minAreaRect(contour);
        if (verifySizes(rotatedRect,resizeFactor) && rotatedRect.size.width > 0 && rotatedRect.size.height > 0 ) {
            rotatedRect.center.x /= resizeFactor;
            rotatedRect.center.y /= resizeFactor;
            rotatedRect.size.width /= resizeFactor;
            rotatedRect.size.height /= resizeFactor;
        
            BusinessCard b = BusinessCard(cv::Mat(rotatedRect.size.width,rotatedRect.size.height,CV_8UC2));
            this->setCenterX(rotatedRect.center.x);
            this->setCenterY(rotatedRect.center.y);
            Point2f vertices[4];
            rotatedRect.points(vertices);
            
            for (int i = 0; i < 4; i++)
            {
                Point2f p = vertices[i];
                
                this->temp[i] = p;
            }
        
            businessCard.push_back(b);
             break;
        }
    }
}


const cv::Mat &BusinessCardDetector::getMask() const {
    return edges;
}
bool BusinessCardDetector::verifySizes(RotatedRect mr,double factor)
{
    //    float error = 0.2;
    
    int minW = 9.4 * 4.8 * pow(50, 2);
    int maxW = 9.4 * 5.8 * pow(180, 2);
    float minAspect = 9.4 / 5.8;
    float maxAspect = 9.4 / 4.8;
    
    int area = mr.size.height / factor * mr.size.width / factor;
    float r = MAX(mr.size.width, mr.size.height)*1.0 / MIN(mr.size.width, mr.size.height) ;
    
    if ((area > maxW || area < minW ) || (r < minAspect || r > maxAspect))
    {
        return  false;
    }
    return true;
}
void BusinessCardDetector::createMask(const cv::Mat &image) {
    
    // Find the image's mean color. //均值
    // Presumably, this is the background color.
    // Also find the standard deviation.
    cv::Scalar meanColor;
    cv::Scalar stdDevColor;
    cv::meanStdDev(image, meanColor, stdDevColor);
    
    // Create a mask based on a range around the mean color.
    cv::Scalar halfRange = MASK_STD_DEVS_FROM_MEAN * stdDevColor;
    cv::Scalar lowerBound = meanColor - halfRange;
    cv::Scalar upperBound = meanColor + halfRange;
    cv::inRange(image, lowerBound, upperBound, mask);
    
    // Erode the mask to merge neighboring blobs.
    int kernelWidth = (int)(MIN(image.cols, image.rows) * MASK_EROSION_KERNEL_RELATIVE_SIZE_IN_IMAGE);
    if (kernelWidth > 0) {
        cv::Size kernelSize(12, 3);
        cv::Mat kernel = cv::getStructuringElement(cv::MORPH_RECT, kernelSize);
        //        cv::erode(mask, mask, kernel, cv::Point(-1, -1), MASK_NUM_EROSION_ITERATIONS);
        cv::morphologyEx(mask, mask, 0, kernel);
    }
}
