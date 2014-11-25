//
//  HalfCircleMeterView.h
//
//  Created by Julien Coudsi on 25/11/2014.
//  Copyright (c) 2014 Julien Coudsi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HalfCircleMeterView : UIView

/**
 * @brief The maximum value of the meter (mandatory).
 **/
@property CGFloat maximumValue;

/**
 * @brief The current value (default : 0).
 **/
@property CGFloat currentValue;

/**
 * @brief The color for the maximum value.
 **/
@property (nonatomic, strong) UIColor *part2Color;

/**
 * @brief The color for the current value.
 **/
@property (nonatomic, strong) UIColor *part1Color;

/**
 * @brief The color for the current value.
 **/
@property (nonatomic, strong) UIColor *defaultExceedColor;

/**
 * @brief The color for the maximum value.
 **/
@property (nonatomic, strong) NSDictionary *customColorsForCustomExceedRatiosDictionary;

/**
 * @brief Spécifies if text is hidden or not (default value : NO)
 **/
@property (nonatomic) BOOL hideText;

/**
 * @brief The string formatter for text
 **/
@property (nonatomic, strong) NSString *textStringFormatter;

/**
 * @brief The text attributes used to custom text (font, size, color, etc)
 **/
@property (nonatomic, strong) NSDictionary *textAttributes;

@end
