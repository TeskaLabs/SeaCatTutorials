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

- (void)configure;
- (void)refresh;
- (void)disconnect;

- (uint32_t)getStatus;
- (BOOL)isReady;

- (void)sendCSR;
- (void)fetchDeviceCert;

- (void)resetAll;
- (void)resetIdentity;

@end


@protocol SeaCatClientDelegate <NSObject>

@optional
- (void)changedConnectionState:(enum SeaCat_ConnectionState)state;
- (void)changedKeyChainState;

- (NSString *)getServerNamePostfix;
- (NSUInteger)getServerPort;

@end


extern SeaCatClientIntf * SeaCatClient;

extern const OSStatus SeaCat_AssertError;


enum SeaCat_Status
{
	SeaCat_NOT_CONFIGURED   = 0x00000000,

	SeaCat_NAMES            = 0x00000001,

	SeaCat_CA_CERT          = 0x00000010,
	SeaCat_SERVER_CERT      = 0x00000020,

	SeaCat_PUBLIC_KEY       = 0x00000100,
	SeaCat_PRIVATE_KEY      = 0x00000200,
	SeaCat_CSR_SENT         = 0x00000400,
	SeaCat_IDENTITY         = 0x00000800,

	SeaCat_CONN_RESOLVING	= 0x00010000,
	SeaCat_CONN_CONNECTING	= 0x00020000,
	SeaCat_CONN_SECURING	= 0x00040000,
	SeaCat_CONN_ESTABLISHED = 0x00080000, // Can be anonymous ...
	SeaCat_CONN_AUTHORIZED  = 0x00100000,
	SeaCat_CONN_ERROR       = 0x00200000,
};


enum SeaCat_Error
{
	SeaCat_Error_AUTH_FAILED = 77701,
	SeaCat_Error_CLIENT_TERMINATED = 77702,
	SeaCat_Error_STREAM_ID_OVERFLOW = 77703,
	SeaCat_Error_SERVER_RESOLVE_FAILED = 77704,
	SeaCat_Error_SERVER_CONNECT_FAILED = 77705,
	SeaCat_Error_SSL_HANDSHAKE_FAILED = 77706,
	SeaCat_Error_UNEXPECTED_SERVER_CERT = 77706,
	SeaCat_Error_BAD_CERTIFICATE = 77707,
	SeaCat_Error_INVALID_INBOUND_FRAME = 77708,
	SeaCat_Error_SERVER_CLOSED_CONN = 77709,
	SeaCat_Error_CLIENT_DISCONNECT = 77710,
	SeaCat_Error_CLIENT_TIMEOUT = 77711,

	SeaCat_Error_GENERIC_ERROR = 77713,

};

enum SeaCat_ConnectionState
{
	SeaCat_ConnectionState_NOT_CONNECTED = 0,
	SeaCat_ConnectionState_RESOLVING = 1,
	SeaCat_ConnectionState_CONNECTING = 2,
	SeaCat_ConnectionState_SSL_HANDSHAKE = 3,
	SeaCat_ConnectionState_CONNECTED = 4,
	SeaCat_ConnectionState_ERROR = -1
};

