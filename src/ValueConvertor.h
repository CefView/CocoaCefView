#pragma once

#import <Foundation/Foundation.h>

#pragma region cef_headers
#include <include/cef_app.h>
#pragma endregion cef_headers

@interface ValueConvertor : NSObject

+ (CefRefPtr<CefValue>)CefValueFromNSValue:(const NSObject*)oValue;

+ (NSObject*)NSValueFromCefValue:(const CefRefPtr<CefValue>&)cValue;

@end
