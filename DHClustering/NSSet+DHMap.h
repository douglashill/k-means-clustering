// Douglas Hill, October 2014
// https://github.com/douglashill/DHClustering

@import Foundation;

@interface NSSet (DHMap)

- (NSSet *)dh_setByMappingObjectsUsingMap:(id (^)(id object))map;

@end
