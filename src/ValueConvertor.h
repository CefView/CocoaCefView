#pragma once

#import <Foundation/Foundation.h>

#pragma region cef_headers
#include <include/cef_app.h>
#pragma endregion cef_headers

@interface ValueConvertor : NSObject

+ (CefRefPtr<CefValue>)CefValueFromNSValue:(NSObject*)oValue;

+ (NSObject*)NSValueFromCefValue:(CefRefPtr<CefValue>&)cValue;

@end
