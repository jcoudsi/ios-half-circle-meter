//
//  HalfCircleMeterView.m
//
//  Created by Julien Coudsi on 25/11/2014.
//

#import "HalfCircleMeterView.h"

@implementation HalfCircleMeterView


#pragma mark Initialization

/**
 * @brief Initializes the round meter component with default values .
 *
 **/
- (void) initialize
{
    self.part1Color = [UIColor greenColor];
    self.part2Color = [UIColor grayColor];
    self.defaultExceedColor = [UIColor redColor];
    self.hideText = NO;
    
    self.textStringFormatter = @"%.0f";
    
    NSMutableParagraphStyle *Paragraph=[[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    Paragraph.lineBreakMode=NSLineBreakByTruncatingTail;
    self.textAttributes = @{
                           NSForegroundColorAttributeName:[UIColor blueColor]
                           ,NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15.0f]
                           ,NSParagraphStyleAttributeName:Paragraph
                           };
    
    self.currentValue = 0;
    self.maximumValue = 0;
    
    //The component must be redraw when the bounds changes (for example after rotation)
    self.contentMode = UIViewContentModeRedraw;
}

#pragma mark Constructors

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self initialize];
    }
    
    return self;
}

#pragma mark Drawing

- (CGFloat) getRadiansFromDegrees:(CGFloat) degrees withClockwise:(BOOL)clockWise
{

    CGFloat degreesCalc = clockWise ? degrees : 360 - (degrees == 0 ? 360 : degrees);
    
    return ((3.14159265359*degreesCalc)/180);
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    /* PREPARES DATA FOR DRAWING */
    
    CGFloat ratio = (float)self.currentValue/self.maximumValue;
    
    CGFloat exceededRatio = 0;
    
    //If the ratio exceeds 1
    if (ratio > 1)
    {
        BOOL isCustomExceededRatioColorAffected = NO;
        
        //If custom exceed ratio colors are specified by the user and if the exceed ratio matches with one, the color is used
        if (self.customColorsForCustomExceedRatiosDictionary)
        {
            exceededRatio = (ratio - 1.f)*100;
            for (NSNumber *ratio in self.customColorsForCustomExceedRatiosDictionary)
            {
                if (exceededRatio < [ratio floatValue])
                {
                    self.part2Color  = self.customColorsForCustomExceedRatiosDictionary[ratio];
                    isCustomExceededRatioColorAffected = YES;
                }
            }
            
        }
        
        //If there aren't custom exceed ratio colors specified by the user or if the exceed ratio doesn't match, the default exceed color is used
        if (!isCustomExceededRatioColorAffected)
        {
            self.part2Color = self.defaultExceedColor;
        }
        
        ratio = 1/ratio;
    }
    
    //Gets the view size
    CGFloat viewHeight = self.bounds.size.height;
    CGFloat viewWidth = self.bounds.size.width;
    
    //Gets the radius of the half circle.
    CGFloat radius = 0.f;
    //Tests in order to the half circle meter always fits in the view, despite its width and height.
    //If the height is longer than the half of the width, it can't be used as the radius because the
    //diameter will be bigger than the view width.
    if (viewHeight < viewWidth / 2)
    {
        radius = viewHeight;
    }
    else
    {
        radius = viewWidth/2;
    }
    
    //Gets angle of sthe first part of the circle
    CGFloat anglePart1 = 180*(1-ratio);
    //Positionning at the middle of the view
    CGPoint center = CGPointMake(viewWidth/2, viewHeight);
    
    /* DRAWING */
    
    //Drawing the first part (maximum value part or current value part when it exceeds the maximum value)
    UIBezierPath *part2Path = [UIBezierPath bezierPath];
    [part2Path moveToPoint:center];
    [part2Path addArcWithCenter:center
                       radius:radius
                   startAngle:0
                     endAngle:[self getRadiansFromDegrees:anglePart1 withClockwise:NO]
                    clockwise:NO];
    [part2Path closePath];
    [self.part2Color setFill];
    [part2Path fill];
    
    //Drawing the second part (current value part or maximum value part when the current value exceeds the maximum value)
    UIBezierPath *part1Path = [UIBezierPath bezierPath];
    [part1Path moveToPoint:center];
    [part1Path addArcWithCenter:center
                         radius:radius
                     startAngle:[self getRadiansFromDegrees:anglePart1 withClockwise:NO]
                       endAngle:[self getRadiansFromDegrees:180 withClockwise:NO]
                      clockwise:NO];
    [part1Path closePath];
    [self.part1Color setFill];
    [part1Path fill];
    
    /* TEXT */
    
    if (!self.hideText)
    {
        //Current value
        NSString * TZero=[NSString stringWithFormat:self.textStringFormatter,self.currentValue];
        [TZero drawAtPoint:CGPointMake(part1Path.bounds.size.width/2 - [TZero sizeWithAttributes:self.textAttributes].width/2, self.bounds.size.height-50) withAttributes:self.textAttributes];
    }

}

@end
