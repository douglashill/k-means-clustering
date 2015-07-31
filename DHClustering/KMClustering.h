// Douglas Hill, October 2014
// https://github.com/douglashill/k-means-clustering

@import Foundation;

#import "KMCluster.h"
#import "KMVector.h"

NS_ASSUME_NONNULL_BEGIN

/// Runs the k-means clustering algorithm `maxIterations` times. The objects in both `initialMeans` and `observationVectors` must conform to the `KMVector` protocol. Returns a set of `KMCluster`s.
NSSet<KMCluster *> *clustersWithInitialMeansAndObservations(NSSet<id<KMVector>> *initialMeans, NSSet<id<KMVector>> *observationVectors, NSUInteger maxIterations);

NS_ASSUME_NONNULL_END
