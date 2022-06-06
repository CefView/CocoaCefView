//
//  CocoaCefContext+Internal.h
//  CocoaCefView
//
//  Created by Sheen Tian Shen on 2022/2/15.
//

#import <CocoaCefView/CocoaCefContext.h>

#include <memory>
#include <string>
#include <list>

#include <include/cef_app.h>

#include <CefViewBrowserClient.h>
#include <CefViewBrowserClientDelegate.h>

#include "CocoaCefClientDelegate.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct ResourceMapping
{
  ResourceMapping(const std::string& p, const std::string& u, const std::string& pwd, int pri)
    : path(p)
    , url(u)
    , password(pwd)
    , priority(pri)
  {
  }

  std::string path;
  std::string url;
  std::string password;
  int priority;
} ResourceMapping;

typedef std::list<ResourceMapping> ResourceMappingList;

@interface
CocoaCefContext ()

- (bool)initCefContext:(CocoaCefConfig*)config;

- (const ResourceMappingList&)getFolderResourceMappingList;

- (const ResourceMappingList&)getArchiveResourceMappingList;

- (CefRefPtr<CefViewBrowserApp>)getCefApp;

- (void)runCefMessageLoop;

- (void)quitCefMessageLoop;

- (void)uninitCefContext;

- (void)exitApplication;

- (void)closeAllBrowsers;

- (void)scheduleCefLoopWork:(int64_t)delayMs;

@end

NS_ASSUME_NONNULL_END
