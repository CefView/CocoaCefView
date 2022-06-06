//
//  CocoaCefDelegate.m
//  CocoaCefView
//
//  Created by Sheen Tian on 1/24/21.
//

#import "CocoaCefClientDelegate.h"

#include "CocoaCefView+Internal.h"
#include "CocoaCefQuery+Internal.h"
#include "ValueConvertor.h"

CocoaCefClientDelegate::CocoaCefClientDelegate(CocoaCefView* cocoaCefView)
  : _cocoaCefView(cocoaCefView)
{
}

void
CocoaCefClientDelegate::processUrlRequest(const std::string& url)
{
}

void
CocoaCefClientDelegate::processQueryRequest(CefRefPtr<CefBrowser>& browser,
                                            int64_t frameId,
                                            const std::string& query,
                                            const int64_t query_id)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    NSString* request = [NSString stringWithUTF8String:query.c_str()];
    CocoaCefQuery* q = [CocoaCefQuery queryWithRequest:request AndId:query_id];
    [cocoaCefView onCefQueryRequest:browser->GetIdentifier() Frame:frameId Query:q];
  }
}

void
CocoaCefClientDelegate::focusedEditableNodeChanged(CefRefPtr<CefBrowser>& browser,
                                                   int64_t frameId,
                                                   bool focusOnEditableNode)
{
}

void
CocoaCefClientDelegate::invokeMethodNotify(CefRefPtr<CefBrowser>& browser,
                                           int64_t frameId,
                                           const std::string& method,
                                           const CefRefPtr<CefListValue>& arguments)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    NSString *strMethod = [NSString stringWithUTF8String:method.c_str()];

    // extract the arguments
    NSMutableArray *argsList = [[NSMutableArray alloc] init];
    for (int i = 0; i < arguments->GetSize(); i++) {
      auto cV = arguments->GetValue(i);
      NSObject* oV = [ValueConvertor NSValueFromCefValue:cV];
      [argsList addObject:oV];
    }
    
    [cocoaCefView onInvokeMethod:browser->GetIdentifier() Frame:frameId Method:strMethod Arguments:argsList];
  }
}

void
CocoaCefClientDelegate::reportJSResult(CefRefPtr<CefBrowser>& browser,
                                       int64_t frameId,
                                       int64_t contextId,
                                       const CefRefPtr<CefValue>& result)
{
  @autoreleasepool {
    CocoaCefView* cocoaCefView = _cocoaCefView;
    NSObject* r = [ValueConvertor NSValueFromCefValue:result];
    [cocoaCefView onReportJavascriptResult:browser->GetIdentifier() Frame:frameId Context:contextId Result:r];
  }
}
