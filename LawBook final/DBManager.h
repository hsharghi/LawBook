//
//  DBManager.h
//  LawBook final
//
//  Created by saeid1 on 9/2/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject

- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename;


@property(nonatomic, strong) NSMutableArray *arrColumnNames;
@property(nonatomic) int affectedRows;
@property(nonatomic) long long lastInsertedRowID;


@property(nonatomic, strong) NSMutableArray *arrColumnNames2;
@property(nonatomic) int affectedRows2;
@property(nonatomic) long long lastInsertedRowID2;


//---------------------------------





@property(nonatomic, strong) NSString *documentsDirectory;


@property(nonatomic, strong) NSString *db_name1;
@property(nonatomic, strong) NSMutableArray *result;
@property(nonatomic, strong) NSString *fullname;


@property(nonatomic, strong) NSString *db_name2;
@property(nonatomic, strong) NSString *temp;


- (NSArray *)getColumn:(const char *)query;


- (NSArray *)loadDataFromDB:(NSString *)query;

- (void)executeQuery:(NSString *)query;

- (void)executeQuery2:(NSString *)query q2:(NSString *)q2;


@end
