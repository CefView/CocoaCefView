#pragma once

#import <Foundation/Foundation.h>

#pragma region cef_headers
#include <include/cef_app.h>
#pragma endregion cef_headers

class ValueConvertor
{
public:
  /// <summary>
  ///
  /// </summary>
  /// <param name="oValue"></param>
  /// <param name="cValue"></param>
  static void CefValueToNSValue(NSObject* oValue, CefValue* cValue);

  /// <summary>
  ///
  /// </summary>
  /// <param name="cValue"></param>
  /// <param name="oValue"></param>
  static void NSValueToCefValue(CefValue* cValue, const NSObject* oValue);
};
