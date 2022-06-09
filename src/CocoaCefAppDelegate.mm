//
//  CocoaCefAppDelegate.m
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import "CocoaCefAppDelegate.h"

CocoaCefAppDelegate::CocoaCefAppDelegate(CocoaCefContext* context, CommandLineArgs args)
  : _context(context)
  , _commandLineArgs(args)
{
}

void
CocoaCefAppDelegate::onBeforeCommandLineProcessing(const CefString& process_type,
                                                   CefRefPtr<CefCommandLine> command_line)
{
  for (auto& kv : _commandLineArgs) {
    if (!kv.first.empty()) {
      if (!kv.second.empty())
        command_line->AppendSwitchWithValue(kv.first, kv.second);
      else
        command_line->AppendSwitch(kv.first);
    }
  }
}

void
CocoaCefAppDelegate::OnBeforeChildProcessLaunch(CefRefPtr<CefCommandLine> command_line)
{
  for (auto& kv : _commandLineArgs) {
    if (!kv.first.empty()) {
      if (!kv.second.empty())
        command_line->AppendSwitchWithValue(kv.first, kv.second);
      else
        command_line->AppendSwitch(kv.first);
    }
  }
}

void
CocoaCefAppDelegate::onScheduleMessageLoopWork(int64_t delay_ms)
{
  @autoreleasepool {
    CocoaCefContext* context = _context;
    [context scheduleCefLoopWork:delay_ms];
  }
}
