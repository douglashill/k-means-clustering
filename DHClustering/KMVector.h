// Douglas Hill, October 2014
// https://github.com/douglashill/k-means-clustering

@protocol KMVector <NSObject>

+ (id <KMVector>)meanOfVectors:(NSSet *)vectors;

- (double)distanceFromVector:(id <KMVector>)otherVector;

@end
