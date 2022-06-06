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

class CocoaCefAppDelegate : public CefViewBrowserAppDelegateInterface
{
  typedef std::unordered_map<std::string, std::string> CommandLineArgs;

public:
  CocoaCefAppDelegate(CocoaCefContext* context, CommandLineArgs args);

  virtual void onBeforeCommandLineProcessing(const CefString& process_type,
                                             CefRefPtr<CefCommandLine> command_line) override;

  virtual void OnBeforeChildProcessLaunch(CefRefPtr<CefCommandLine> command_line) override;

  virtual void onScheduleMessageLoopWork(int64_t delay_ms) override;

private:
  CocoaCefContext* __weak _context;

  CommandLineArgs _commandLineArgs;
};

NS_ASSUME_NONNULL_END
