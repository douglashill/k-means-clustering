// Douglas Hill, October 2014
// https://github.com/douglashill/k-means-clustering

@import Foundation;

@interface NSSet<ObjectType> (DHMap)

- (NSSet *)dh_setByMappingObjectsUsingMap:(id (^)(ObjectType object))map;

@end
