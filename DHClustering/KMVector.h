// Douglas Hill, October 2014
// https://github.com/douglashill/k-means-clustering

@protocol KMVector <NSObject>

+ (id <KMVector>)meanOfVectors:(NSSet *)vectors;

- (float)distanceFromVector:(id <KMVector>)otherVector;

@end
