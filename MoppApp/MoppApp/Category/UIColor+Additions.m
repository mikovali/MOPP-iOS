//
//  UIColor+Additions.m
//  MoppApp
//
/*
 * Copyright 2017 Riigi Infosüsteemide Amet
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 */

#import "UIColor+Additions.h"

NSString *const kThemeDarkGreen = @"5DA54B";
NSString *const kThemeRed = @"d52d37";
NSString *const kThemeDarkBlue = @"00365C";
NSString *const kThemeWarningIconTint = @"FF9033";
NSString *const kThemeWarningBackgroundColor = @"FFF4E1";
NSString *const kThemeWarningBorderColor = @"FBE3BC";
NSString *const kThemeErrorIconTint = @"EC0821";
NSString *const kThemeErrorBackgroundColor = @"FFE6E6";
NSString *const kThemeErrorBorderColor = @"FFCED0";
NSString *const kThemeSelectedTextColor = @"006FFF";

@implementation UIColor (Additions)

+ (UIColor *)colorFromHexString:(NSString *)hexString {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString alpha:(CGFloat)alpha {
  unsigned rgbValue = 0;
  NSScanner *scanner = [NSScanner scannerWithString:hexString];
  [scanner scanHexInt:&rgbValue];
  return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

+ (UIColor *)darkGreen {
  return [self colorFromHexString:kThemeDarkGreen];
}

+ (UIColor *)darkBlue {
  return [self colorFromHexString:kThemeDarkBlue];
}

+ (UIColor *)red {
  return [self colorFromHexString:kThemeRed];
}

+ (UIColor *)warningIconTint {
  return [self colorFromHexString:kThemeWarningIconTint];
}

+ (UIColor *)warningBackgroundColor {
  return [self colorFromHexString:kThemeWarningBackgroundColor];
}

+ (UIColor *)warningBorderColor {
  return [self colorFromHexString:kThemeWarningBorderColor];
}

+ (UIColor *)errorIconTint {
  return [self colorFromHexString:kThemeErrorIconTint];
}

+ (UIColor *)errorBackgroundColor {
  return [self colorFromHexString:kThemeErrorBackgroundColor];
}

+ (UIColor *)errorBorderColor {
  return [self colorFromHexString:kThemeErrorBorderColor];
}

+ (UIColor *)selectedTextColor {
  return [self colorFromHexString:kThemeSelectedTextColor];
}

@end
