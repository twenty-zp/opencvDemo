//
//  BusinessCard.hpp
//  opencvDemo
//
//  Created by zp on 2017/9/18.
//  Copyright © 2017年 ilogie. All rights reserved.
//

#ifndef BusinessCard_hpp
#define BusinessCard_hpp

#include <stdio.h>
#include <opencv2/core.hpp>

class BusinessCard
{
public:
    BusinessCard(const cv::Mat &mat,uint32_t label = 0ul);
    
    /**
     * Construct an empty blob.
     */
    BusinessCard();
    
    /**
     * Construct a blob by copying another blob.
     */
    BusinessCard(const BusinessCard &other);
    
    bool isEmpty() const;
    
    const cv::Mat &getMat() const;
    int getWidth() const;
    int getHeight() const;

    
private:
    cv::Point2f center;

    cv::Mat mat;
};
#endif /* BusinessCard_hpp */
