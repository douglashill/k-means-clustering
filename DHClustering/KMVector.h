// Douglas Hill, October 2014
// https://github.com/douglashill/k-means-clustering

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@protocol KMVector <NSObject>

+ (id<KMVector>)meanOfVectors:(NSSet<id<KMVector>> *)vectors;

- (float)distanceFromVector:(id<KMVector>)otherVector;

@end

NS_ASSUME_NONNULL_END
