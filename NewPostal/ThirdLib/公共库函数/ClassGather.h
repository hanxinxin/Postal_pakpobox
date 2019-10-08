//
//  ClassGather.h
//  NewPostal
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassGather : NSObject

@end


@interface packetsMode : NSObject
@property (nonatomic,strong)NSString * lockerId;
@property (nonatomic,strong)NSString * lockerName;
@property (nonatomic,strong)NSString * location;
@property (nonatomic,strong)NSNumber * letterCount;
@property (nonatomic,strong)NSString * pinCode;

@end
@interface ParcelMode : NSObject
@property (nonatomic,strong)NSString * location;
@property (nonatomic,strong)NSString * ordersId;
@property (nonatomic,strong)NSString * ordersNumber;
@property (nonatomic,strong)NSString * pinCode;

@end


@interface ParcelInfo : NSObject
@property (nonatomic,strong)NSString * boxName;
@property (nonatomic,strong)NSNumber * expiryTime;
@property (nonatomic,strong)NSString * location;
@property (nonatomic,strong)NSString * lockerName;
@property (nonatomic,strong)NSString * ordersId;
@property (nonatomic,strong)NSString * ordersNumber;
@property (nonatomic,strong)NSString * pinCode;

@end
@interface ZongParcelMode : NSObject
@property (nonatomic,strong)NSString * location;
@property (nonatomic,strong)NSString * lockerName;
@property (nonatomic,strong)NSString * ordersId;
@property (nonatomic,strong)NSString * ordersNumber;
@end

@interface AddressInfoMode : NSObject
@property (nonatomic,strong)NSString * Type;   ////Receiver 收件人   Sender/寄件人
@property (nonatomic,strong)NSString * addressFullName;
@property (nonatomic,strong)NSString * addressLine1;
@property (nonatomic,strong)NSString * addressLine2;
@property (nonatomic,strong)NSString * country;
@property (nonatomic,strong)NSString * countryCallingCode;
@property (nonatomic,strong)NSString * mobile;
@property (nonatomic,strong)NSString * ordersAddressId;
@property (nonatomic,strong)NSString * postalCode;

@end

@interface DetaInfoMode : NSObject
@property (nonatomic,strong)NSString * ordersId;
@property (nonatomic,strong)NSString * ordersNumber;
@property (nonatomic,strong)NSString * ordersType;
@property (nonatomic,strong)AddressInfoMode * senderAddress;
@property (nonatomic,strong)AddressInfoMode * receiverAddress;
@end

@interface AddressListMode : NSObject
@property (nonatomic,strong)NSString * userAddressId;
@property (nonatomic,strong)NSString * addressFullName;
@property (nonatomic,strong)NSString * addressLine1;
@property (nonatomic,strong)NSString * addressLine2;
@property (nonatomic,strong)NSString * country;
@property (nonatomic,strong)NSString * countryCallingCode;
@property (nonatomic,strong)NSString * defaultFlag;
@property (nonatomic,strong)NSString * mobile;
@property (nonatomic,strong)NSString * postalCode;

@end

@interface PostListMode : NSObject
@property (nonatomic,strong)NSString * ordersId;
@property (nonatomic,strong)NSString * ordersNumber;

@end

NS_ASSUME_NONNULL_END
