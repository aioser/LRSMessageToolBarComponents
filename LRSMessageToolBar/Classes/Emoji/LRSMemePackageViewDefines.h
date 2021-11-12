//
//  LRSMemePackageViewDefines.h
//  LRSMessageToolBar
//
//  Created by sama 刘 on 2021/11/3.
//

#import <Foundation/Foundation.h>
@class LRSMemePackageConfigureItem;
@class LRSMemeSinglePage;
@class LRSMemePackagesView;
NS_ASSUME_NONNULL_BEGIN
typedef void(^LRSMemePackageItemsHandler)(LRSMemeSinglePage *view, LRSMemePackageConfigureItem *item);
typedef void(^LRSMemePackageBackspaceHandler)(LRSMemeSinglePage *view);
typedef void(^LRSMemePackageSendOutHandler)(LRSMemePackagesView *view);
NS_ASSUME_NONNULL_END
