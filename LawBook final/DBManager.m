//
//  DBManager.m
//  LawBook final
//
//  Created by saeid1 on 9/2/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "DBManager.h"

@interface DBManager ()


- (void)copyDatabaseIntoDocumentsDirectory;

- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end


@implementation DBManager


- (instancetype)initWithDatabaseFilename:(NSString *)dbFilename {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        self.db_name1 = dbFilename;
        self.fullname = [self.documentsDirectory stringByAppendingPathComponent:self.db_name1];
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}


- (void)copyDatabaseIntoDocumentsDirectory {

    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.db_name1];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.db_name1];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}


- (void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable {
    // Create a sqlite object.
    sqlite3 *sqlite3Database;

    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.db_name1];

    // Initialize the results array.
    if (self.result != nil) {
        [self.result removeAllObjects];
        self.result = nil;
    }
    self.result = [[NSMutableArray alloc] init];

    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];


    // Open the database.
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if (openDatabaseResult == SQLITE_OK) {
        // Declare a sqlite3_stmt object in which will be stored the query after having been compiled into a SQLite statement.
        sqlite3_stmt *compiledStatement;

        // Load all data from database to memory.
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if (prepareStatementResult == SQLITE_OK) {
            // Check if the query is non-executable.
            if (!queryExecutable) {
                // In this case data must be loaded from the database.

                // Declare an array to keep the data for each fetched row.
                NSMutableArray *arrDataRow;

                // Loop through the results and add them to the results array row by row.
                while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                    // Initialize the mutable array that will contain the data of a fetched row.
                    arrDataRow = [[NSMutableArray alloc] init];

                    // Get the total number of columns.
                    int totalColumns = sqlite3_column_count(compiledStatement);

                    // Go through all columns and fetch each column data.
                    for (int i = 0; i < totalColumns; i++) {
                        // Convert the column data to text (characters).
                        char *dbDataAsChars = (char *) sqlite3_column_text(compiledStatement, i);

                        // If there are contents in the currenct column (field) then add them to the current row array.
                        if (dbDataAsChars != NULL) {
                            // Convert the characters to string.
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }

                        // Keep the current column name.
                        if (self.arrColumnNames.count != totalColumns) {
                            dbDataAsChars = (char *) sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }

                    // Store each fetched data row in the results array, but first check if there is actually data.
                    if (arrDataRow.count > 0) {
                        [self.result addObject:arrDataRow];
                    }
                }
            }
            else {
                // This is the case of an executable query (insert, update, ...).

                // Execute the query.
                BOOL executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);

                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else {
                    // If could not execute the query show the error message on the debugger.
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }

        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);

    }

    // Close the database.
    sqlite3_close(sqlite3Database);


}


- (void)runQuery:(const char *)query q2:(const char *)query2 {
    // Create a sqlite object.
    sqlite3 *sqlite3Database;


    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.db_name1];

    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if (openDatabaseResult == SQLITE_OK) {

        sqlite3_stmt *compiledStatement;
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if (prepareStatementResult == SQLITE_OK) {


            const char *e = sqlite3_bind_parameter_name(compiledStatement, 1);
            BOOL executeQueryResults = sqlite3_step(compiledStatement);
            if (executeQueryResults == SQLITE_DONE) {

                NSLog(@"hehe", @"yesyyesy");

            }
            else {
                NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
            }

        }
        else {

            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }
        sqlite3_finalize(compiledStatement);

    }
    sqlite3_close(sqlite3Database);
}





//-(NSString *)get_type:(NSString *)n table:(NSString *)t
//{
//    // Create a sqlite object.
//    const char *name=[n UTF8String];
//    const char *table=[t UTF8String];
//    sqlite3 *sqlite3Database;
//    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.db_name1];
//    
//    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
//    
//    
//    if( openDatabaseResult==SQLITE_OK) {
//        
//        sqlite3_stmt *compiledStatement;
//        sqlite3_column_type(<#sqlite3_stmt *#>, <#int iCol#>)
//        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
//        if(prepareStatementResult == SQLITE_OK)
//        {
//            
//            
//            const char *e=sqlite3_bind_parameter_name(compiledStatement, 1);
//            BOOL executeQueryResults = sqlite3_step(compiledStatement);
//            if (executeQueryResults == SQLITE_DONE)
//            {
//                
//                NSLog(@"hehe", @"yesyyesy");
//                
//            }
//            else
//            {
//                NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
//            }
//            
//        }
//        else {
//            
//            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
//        }
//        sqlite3_finalize(compiledStatement);
//        
//    }
//    sqlite3_close(sqlite3Database);
//}
































- (NSArray *)getColumn:(const char *)query {

    sqlite3 *sqlite3Database;
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.db_name1];
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];

    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if (openDatabaseResult == SQLITE_OK) {
        sqlite3_stmt *compiledStatement;
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if (prepareStatementResult == SQLITE_OK) {

            NSMutableArray *arrDataRow;
            while (sqlite3_step(compiledStatement) == SQLITE_ROW) {
                arrDataRow = [[NSMutableArray alloc] init];
                int totalColumns = sqlite3_column_count(compiledStatement);
                for (int i = 0; i < totalColumns; i++) {

                    char *dbDataAsChars;
                    if (self.arrColumnNames.count != totalColumns) {
                        dbDataAsChars = (char *) sqlite3_column_name(compiledStatement, i);
                        [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                    }
                }


            }


        }
        else {
            // In the database cannot be opened then show the error message on the debugger.
            NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        }

        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);

    }


    sqlite3_close(sqlite3Database);
    return self.arrColumnNames;
}


- (NSArray *)loadDataFromDB:(NSString *)query {
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.

    [self runQuery:[query UTF8String] isQueryExecutable:NO];

    // Returned the loaded results.
    return (NSArray *) self.result;
}

- (void)executeQuery:(NSString *)query {
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}


- (void)executeQuery2:(NSString *)query q2:(NSString *)q2 {
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] q2:[q2 UTF8String]];
}












//
//
//
//
//- (void)attach {
//    
//    // PREPARE
//    sqlite3 *database = NULL ;
//    //BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
//    sqlite3_stmt *stm;
//    NSString *tempString = [NSString stringWithFormat:@"ATTACH DATABASE '%@' AS db_default", self.fullname];
//    
//    const char *sql = (char *)[tempString UTF8String];
//    if (sqlite3_prepare_v2(database, sql, -1, &stm, NULL) != SQLITE_OK) {
//        NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
//    }
//    
//    
//    
//    
//    // STEP
//    NSInteger rc = sqlite3_step(stm);
//    if(rc != SQLITE_DONE) {
//        NSAssert1(0, @"Error: failed to step through statement with message '%s'.", sqlite3_errmsg(database));
//    }
//    
//    // RESET
//    sqlite3_reset(stm);
//}
//
//
//
//
//
//
//
//
//
//
//- (void)beginTransaction {
//    
//    // PREPARE
//    sqlite3 *database = NULL ;
//    sqlite3_stmt *stm = NULL;
//    if (stm == nil) {
//        const char *sql = "BEGIN TRANSACTION";
//        if (sqlite3_prepare_v2(database, sql, -1, &stm, NULL) != SQLITE_OK) {
//            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
//        }
//    }
//    
//    // STEP
//    NSInteger rc = sqlite3step(stm);
//    if(rc != SQLITE_DONE) {
//        NSAssert1(0, @"Error: failed to step through statement with message '%s'.", sqlite3_errmsg(database));
//    }
//    
//    // RESET
//    sqlite3_reset(stm);
//}
//
//
//
//
//
//
//
//
//
//
//
//- (void)copy_table: (NSString *)table {
//    
//    sqlite3_stmt *stm = NULL;
//    sqlite3 *database = NULL ;
//    NSString *tempString = [NSString stringWithFormat:@"CREATE TABLE BookDoenload.%@ AS SELECT * FROM db_default.%@",table,table];
//    if (stm == nil) {
//        const char *sql = "CREATE TABLE main.customer AS SELECT * FROM db_default.customer";
//        if (sqlite3_prepare_v2(database, sql, -1, &stm, NULL) != SQLITE_OK) {
//            NSAssert1(0, @"Error: failed to prepare statement with message '%s'.", sqlite3_errmsg(database));
//        }
//    }
//    
//    // STEP
//    NSInteger rc = sqlite3step(stm);
//    if(rc != SQLITE_DONE) {
//        NSAssert1(0, @"Error: failed to step through statement with message '%s'.", sqlite3_errmsg(database));
//    }
//    
//    // RESET
//    sqlite3_reset(stm);
//    
//}
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//



@end
