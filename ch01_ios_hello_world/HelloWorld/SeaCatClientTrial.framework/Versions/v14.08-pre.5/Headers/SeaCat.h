//
//  SeaCat iOS Client
//  More info at http://www.seacat.mobi/
//
//  Copyright (c) 2013-2014 Seal Teaks Ltd
//  All rights reserved.
//

#import <Foundation/Foundation.h>

enum SeaCat_ConnectionState;
@protocol SeaCatClientDelegate;


@interface SeaCatClientIntf : NSObject

@property (nonatomic, weak) id<SeaCatClientDelegate> delegate;
@property (readonly) BOOL isTrial;
@property enum SeaCat_InterceptMode interceptMode;

- (void)configure;
- (void)configure:(id<SeaCatClientDelegate>)delegate;

- (void)refresh;
- (void)disconnect;

- (uint32_t)getStatus;
- (BOOL)isReady;

- (void)sendCSR;
- (void)fetchDeviceCert;

- (void)resetAll;
- (void)resetIdentity;

- (NSString *)getVersionString;

@end


@protocol SeaCatClientDelegate <NSObject>

@optional
- (void)seacatChangedConnectionState:(enum SeaCat_ConnectionState)state withError:(NSError *)error;
- (void)seacatChangedKeyChainState;

- (NSString *)seacatGetAppPostfix;
- (NSUInteger)seacatGetGatewayPort;

@end


extern SeaCatClientIntf * SeaCatClient;

extern const OSStatus SeaCat_AssertError;

enum SeaCat_Status
{
	SeaCat_NOT_CONFIGURED   = 0x00000000,

	SeaCat_NAMES            = 0x00000001,

	SeaCat_CA_CERT          = 0x00000010,
	SeaCat_GATEWAY_CERT      = 0x00000020,

	SeaCat_PUBLIC_KEY       = 0x00000100,
	SeaCat_PRIVATE_KEY      = 0x00000200,
	SeaCat_CSR_SENT         = 0x00000400,
	SeaCat_IDENTITY         = 0x00000800,

	SeaCat_CONN_RESOLVING	= 0x00010000,
	SeaCat_CONN_CONNECTING	= 0x00020000,
	SeaCat_CONN_SECURING	= 0x00040000,
	SeaCat_CONN_ESTABLISHED = 0x00080000, // Can be anonymous ...
	SeaCat_CONN_AUTHORIZED  = 0x00100000,
};


enum SeaCat_Error
{
	SeaCat_Error_AUTH_FAILED = 77701,
	SeaCat_Error_CLIENT_TERMINATED = 77702,
	SeaCat_Error_STREAM_ID_OVERFLOW = 77703,
	SeaCat_Error_GATEWAY_RESOLVE_FAILED = 77704,
	SeaCat_Error_GATEWAY_CONNECT_FAILED = 77705,
	SeaCat_Error_SSL_HANDSHAKE_FAILED = 77706,
	SeaCat_Error_UNEXPECTED_GATEWAY_CERT = 77706,
	SeaCat_Error_BAD_CERTIFICATE = 77707,
	SeaCat_Error_INVALID_INBOUND_FRAME = 77708,
	SeaCat_Error_GATEWAY_CLOSED_CONN = 77709,
	SeaCat_Error_CLIENT_DISCONNECT = 77710,
	SeaCat_Error_CLIENT_TIMEOUT = 77711,
	SeaCat_Error_CLIENT_UNKNOWN_CA = 77712,

	SeaCat_Error_GENERIC_ERROR = 77999,
};

enum SeaCat_ConnectionState
{
	SeaCat_ConnectionState_NOT_CONNECTED = 0,
	SeaCat_ConnectionState_RESOLVING = 1,
	SeaCat_ConnectionState_CONNECTING = 2,
	SeaCat_ConnectionState_SSL_HANDSHAKE = 3,
	SeaCat_ConnectionState_CONNECTED = 4
};

enum SeaCat_InterceptMode
{
	SeaCat_InterceptMode_SeaCatExtension = 0,
	SeaCat_InterceptMode_AllHTTP = 1,
};
