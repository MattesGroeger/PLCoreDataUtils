/*
 Copyright (c) 2011, Antoni Kędracki, Polidea
 All rights reserved.

 mailto: akedracki@gmail.com

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the Polidea nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY ANTONI KĘDRACKI, POLIDEA ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL ANTONI KĘDRACKI, POLIDEA BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import <CoreData/CoreData.h>
#import "PLDataSetMerger.h"


@implementation PLDataSetMerger {
    NSManagedObjectContext * context;
    NSMutableSet * entrySet;
}

+(PLDataSetMerger *) mergerWithEntityName:(NSString*)entityName matchingPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)context{
    return [[[self alloc] initWithEntityName:entityName matchingPredicate:predicate inContext:context] autorelease];
}

-(id) initWithEntityName:(NSString*)entityName matchingPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)aContext{
    self = [super init];
    if (self){

        context = [aContext retain];
        entrySet = [[NSMutableSet setWithArray:[context fetchObjectsWithEntityName:entityName predicate:predicate]] retain];
    }
    return self;
}

- (void)dealloc {
    [entrySet release];
    [context release];

    [super dealloc];
}


-(void) mark:(NSManagedObject *)entry{
    [entrySet removeObject:entry];
}

-(NSInteger) removeUnmarked{
    for (NSManagedObject * entry in entrySet){
        [context deleteObject:entry];
    }
    return [entrySet count];
}

@end