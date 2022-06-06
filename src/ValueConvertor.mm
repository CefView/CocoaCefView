#include "ValueConvertor.h"

@implementation ValueConvertor

+ (CefRefPtr<CefValue>)CefValueFromNSValue:(const NSObject*)oValue
{
  auto cVal = CefValue::Create();

  if (!oValue) {
    return cVal;
  }

  if ([oValue isKindOfClass:NSNull.class]) {
    cVal->SetNull();
  } else if ([oValue isKindOfClass:NSNumber.class]) {
    NSNumber* n = (NSNumber*)oValue;
    auto t = CFGetTypeID((__bridge CFTypeRef)(n));
    if (t == CFBooleanGetTypeID()) {
      cVal->SetBool(n.boolValue);
    } else if (t == kCFNumberFloatType || t == kCFNumberDoubleType) {
      cVal->SetDouble(n.doubleValue);
    } else {
      cVal->SetInt(n.intValue);
    }
  } else if ([oValue isKindOfClass:NSString.class]) {
    NSString* s = (NSString*)oValue;
    cVal->SetString([s UTF8String]);
  } else if ([oValue isKindOfClass:NSData.class]) {
    NSData* d = (NSData*)oValue;
    cVal->SetBinary(CefBinaryValue::Create(d.bytes, d.length));
  } else if ([oValue isKindOfClass:NSDictionary.class]) {
    NSDictionary* dict = (NSDictionary*)oValue;
    auto cDict = CefDictionaryValue::Create();
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString* _Nonnull key, id _Nonnull obj, BOOL* _Nonnull stop) {
      auto c = [self CefValueFromNSValue:obj];
      cDict->SetValue(key.UTF8String, c);
    }];
    cVal->SetDictionary(cDict);
  } else if ([oValue isKindOfClass:NSArray.class]) {
    NSArray* list = (NSArray*)oValue;
    auto cList = CefListValue::Create();
    [list enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL* _Nonnull stop) {
      auto c = [self CefValueFromNSValue:obj];
      cList->SetValue(idx, c);
    }];
    cVal->SetList(cList);
  } else {
    cVal->SetNull();
  }

  return cVal;
}

+ (NSObject*)NSValueFromCefValue:(const CefRefPtr<CefValue>&)cValue
{
  if (!cValue) {
    return;
  }

  auto type = cValue->GetType();
  switch (type) {
    case CefValueType::VTYPE_INVALID:
    case CefValueType::VTYPE_NULL: {
      return [NSNull null];
    } break;
    case CefValueType::VTYPE_BOOL: {
      return [NSNumber numberWithBool:cValue->GetBool()];
    } break;
    case CefValueType::VTYPE_INT: {
      return [NSNumber numberWithInt:cValue->GetInt()];
    } break;
    case CefValueType::VTYPE_DOUBLE: {
      return [NSNumber numberWithDouble:cValue->GetDouble()];
    } break;
    case CefValueType::VTYPE_STRING: {
      return [NSString stringWithUTF8String:cValue->GetString().ToString().c_str()];
    } break;
    case CefValueType::VTYPE_BINARY: {
      auto cData = cValue->GetBinary();
      auto cLen = cData->GetSize();
      NSMutableData* data = [NSMutableData dataWithLength:cLen];
      cData->GetData(data.mutableBytes, cLen, 0);
      return data;
    } break;
    case CefValueType::VTYPE_DICTIONARY: {
      NSMutableDictionary* oDic = [[NSMutableDictionary alloc] init];
      auto cDict = cValue->GetDictionary();

      CefDictionaryValue::KeyList cKeys;
      if (!cDict->GetKeys(cKeys)) {
        return oDic;
      }

      for (auto& key : cKeys) {
        auto cVal = cDict->GetValue(key);
        NSString* oKey = [NSString stringWithUTF8String:key.ToString().c_str()];
        auto oVal = [self NSValueFromCefValue:cVal];
        [oDic setObject:oVal forKey:oKey];
      }

      return oDic;
    } break;
    case CefValueType::VTYPE_LIST: {
      NSMutableArray* oList = [[NSMutableArray alloc] init];
      auto cList = cValue->GetList();
      auto cCount = cList->GetSize();

      for (int i = 0; i < cCount; i++) {
        auto cVal = cList->GetValue(i);
        auto oVal = [self NSValueFromCefValue:cVal];
        [oList addObject:oVal];
      }

      return oList;
    } break;
    default:
      return [NSNull null];
  }
}

@end
