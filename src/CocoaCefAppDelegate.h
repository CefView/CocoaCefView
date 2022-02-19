//
//  CocoaCefAppDelegate.h
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import <Foundation/Foundation.h>

#pragma region std_headers
#include <memory>
#pragma endregion std_headers

#pragma region cef_headers
#include <include/cef_app.h>
#pragma endregion cef_headers

#include <CefViewBrowserAppDelegate.h>

#include "CocoaCefContext+Internal.h"

NS_ASSUME_NONNULL_BEGIN

class CocoaCefAppDelegate : public CefViewBrowserAppDelegateInterface {
public:
  CocoaCefAppDelegate(void* context);
  
  void OnScheduleMessageLoopWork(int64_t delay_ms) override;
  
private:
  CocoaCefContext *__weak _context;
};

NS_ASSUME_NONNULL_END
