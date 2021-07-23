#include "CCefManager.h"

#import <Cocoa/Cocoa.h>

#pragma region cef_headers
#include <include/cef_sandbox_mac.h>
#include <include/wrapper/cef_library_loader.h>
#pragma endregion cef_headers

#include <crt_externs.h> // for _NSGetArgc, _NSGetArgv

#import <CocoaCefSetting.h>

#define CEF_FRAMEWORK_NAME "Chromium Embedded Framework.framework"
#define CEF_BINARY_NAME "Chromium Embedded Framework"
#define HELPER_BUNDLE_NAME "CefViewWing.app"
#define HELPER_BINARY_NAME "CefViewWing"
#define COCOA_CEF_VIEW_FRAMEWORK_NAME "CocoaCefView.framework"
#define RESOURCES "Resources"

CCefManager::CCefManager()
: bridgeObjectName()
, debugPort(0)
, backgroundColor(-1)
, is_initialized_(false)
, is_exiting_(false) {
}

CCefManager &CCefManager::getInstance() {
  static CCefManager s_instance;
  return s_instance;
}

bool CCefManager::initializeCef(int argc, const char* argv[]) {
  std::lock_guard<std::mutex> lock(init_locker_);

  // This is not the first time initialization
  if (is_initialized_)
    return true;
  
  // load the cef library
  if (!loadCefLibrary()) {
    return false;
  }
  
  // initialize the settings
  CefSettings cef_settings;
  CefString(&cef_settings.framework_dir_path) = cefFrameworkPath();
  CefString(&cef_settings.browser_subprocess_path) = cefSubprocessPath();
  //CefString(&cef_settings.main_bundle_path) = appMainBundlePath();
  cef_settings.pack_loading_disabled = false;
  cef_settings.external_message_pump = false;
  
#if !defined(CEF_USE_SANDBOX)
  cef_settings.no_sandbox = true;
#endif
  
#if (defined(DEBUG) || defined(_DEBUG) || !defined(NDEBUG))
  cef_settings.log_severity = LOGSEVERITY_DEFAULT;
  cef_settings.remote_debugging_port = 7777;
#else
  cef_settings.log_severity = LOGSEVERITY_DISABLE;
#endif
  
  if (!cacheRootPath.empty())
    CefString(&cef_settings.root_cache_path) = cacheRootPath;
  if (!cachePath.empty())
    CefString(&cef_settings.cache_path) = cachePath;
  
  if (debugPort != 0)
    cef_settings.remote_debugging_port = debugPort;
  if (backgroundColor != -1)
    cef_settings.background_color = backgroundColor;
  
    CefRefPtr<CefViewBrowserApp> app = new CefViewBrowserApp(bridgeObjectName);
  CefMainArgs main_args(argc, (char**)argv);
  if (!CefInitialize(main_args, cef_settings, app, nullptr)) {
    cef_unload_library();
    return false;
  }
  
  app_ = app;
  is_initialized_ = true;
  
  return true;
}

void CCefManager::uninitializeCef() {
  std::lock_guard<std::mutex> lock(init_locker_);

  if (!is_initialized_)
    return;

  // The last time release
  CefShutdown();

  // Destroy te application
  app_ = nullptr;

  freeCefLibrary();
}

bool CCefManager::isInitialized() {
  std::lock_guard<std::mutex> lock(init_locker_);
  return is_initialized_;
}

bool CCefManager::addCookie(const std::string& name,
                            const std::string& value,
                            const std::string& domain,
                            const std::string& url) {
  CefCookie cookie;
  CefString(&cookie.name).FromString(name);
  CefString(&cookie.value).FromString(value);
  CefString(&cookie.domain).FromString(domain);
  return CefCookieManager::GetGlobalManager(nullptr)->SetCookie(CefString(url), cookie, nullptr);
}

void CCefManager::registerBrowserHandler(CefRefPtr<CefViewBrowserHandler> handler) {
  std::lock_guard<std::mutex> lock(handler_set_locker_);
  handler_set_.insert(handler);
}

void CCefManager::removeBrowserHandler(CefRefPtr<CefViewBrowserHandler> handler) {
  std::lock_guard<std::mutex> lock(handler_set_locker_);
  if (handler_set_.empty())
    return;
  
  handler_set_.erase(handler);
  if (handler_set_.empty() && is_exiting_)
    CefQuitMessageLoop();
}

void CCefManager::closeAllBrowserHandler() {
  is_exiting_ = true;
  std::lock_guard<std::mutex> lock(handler_set_locker_);
  if (handler_set_.empty()) {
    CefQuitMessageLoop();
    return;
  }
  
  for (auto handler : handler_set_) {
    handler->CloseAllBrowsers(true);
    NSView* view = (__bridge NSView*)(handler->GetBrowser()->GetHost()->GetWindowHandle());
    [view removeFromSuperview];
  }
}

void CCefManager::runMessageLoop() {
  CefRunMessageLoop();
}

void CCefManager::exitMessageLoop() {
  CefQuitMessageLoop();
}

const char *CCefManager::cefSubprocessPath() {
  static std::string path;
  if (!path.empty())
    return path.c_str();

  @autoreleasepool {
	  //NSString *fxPath = [[NSBundle bundleForClass:CocoaCefSetting.class] resourcePath];
	  NSString *fxPath = [[NSBundle mainBundle] privateFrameworksPath];
	  fxPath = [fxPath stringByAppendingPathComponent:@COCOA_CEF_VIEW_FRAMEWORK_NAME];
	  fxPath = [fxPath stringByAppendingPathComponent:@RESOURCES];
	  fxPath = [fxPath stringByAppendingPathComponent:@HELPER_BUNDLE_NAME];
	  fxPath = [fxPath stringByAppendingPathComponent:@"Contents"];
	  fxPath = [fxPath stringByAppendingPathComponent:@"MacOS"];
	  fxPath = [fxPath stringByAppendingPathComponent:@HELPER_BINARY_NAME];
	  path = fxPath.UTF8String;
  }
  return path.c_str();
}

const char *CCefManager::cefFrameworkPath() {
  static std::string path;
  if (!path.empty())
    return path.c_str();

  @autoreleasepool {
//    NSString *fxPath = [[NSBundle bundleForClass:CocoaCefSetting.class] resourcePath];
	NSString *fxPath = [[NSBundle mainBundle] privateFrameworksPath];
	fxPath = [fxPath stringByAppendingPathComponent:@COCOA_CEF_VIEW_FRAMEWORK_NAME];
	fxPath = [fxPath stringByAppendingPathComponent:@RESOURCES];
	fxPath = [fxPath stringByAppendingPathComponent:@CEF_FRAMEWORK_NAME];
    path = fxPath.UTF8String;
  }
  return path.c_str();
}

const char *CCefManager::cefLibraryPath() {
  static std::string path;
  if (!path.empty())
    return path.c_str();

  path = cefFrameworkPath();
  path += "/";
  path += CEF_BINARY_NAME;
  return path.c_str();
}

const char *CCefManager::appMainBundlePath() {
  static std::string path;
  if (!path.empty())
    return path.c_str();

  @autoreleasepool {
    path = [[[NSBundle mainBundle] bundlePath] UTF8String];
  }
  return path.c_str();
}

bool CCefManager::loadCefLibrary() { return (1 == cef_load_library(cefLibraryPath())); }

void CCefManager::freeCefLibrary() { cef_unload_library(); }
