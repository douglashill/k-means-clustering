// Douglas Hill, October 2014
// https://github.com/douglashill/DHClustering

@protocol KMVector <NSObject>

+ (id <KMVector>)meanOfVectors:(NSSet *)vectors;

- (double)distanceFromVector:(id <KMVector>)otherVector;

@end
