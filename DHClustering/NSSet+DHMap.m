// Douglas Hill, October 2014
// https://github.com/douglashill/DHClustering

#import "NSSet+DHMap.h"

@implementation NSSet (DHMap)

- (NSSet *)dh_setByMappingObjectsUsingMap:(id (^)(id object))map
{
	NSMutableSet *mappedSet = [NSMutableSet setWithCapacity:[self count]];
	
	for (id object in self) {
		id mappedObject = map(object);
		if (mappedObject) [mappedSet addObject:mappedObject];
	}
	
	return mappedSet;
}

@end
