//
//  BusinessCard.cpp
//  opencvDemo
//
//  Created by zp on 2017/9/18.
//  Copyright © 2017年 ilogie. All rights reserved.
//

#include "BusinessCard.hpp"
BusinessCard::BusinessCard(const cv::Mat &mat, uint32_t label)
{
    mat.copyTo(this->mat);
}
BusinessCard::BusinessCard() {
    
}
BusinessCard::BusinessCard(const BusinessCard &other)
{
    other.mat.copyTo(mat);
}

bool BusinessCard::isEmpty() const {
    return mat.empty();
}

const cv::Mat &BusinessCard::getMat() const {
    return mat;
}

int BusinessCard::getWidth() const {
    return mat.cols;
}

int BusinessCard::getHeight() const {
    return mat.rows;
}
