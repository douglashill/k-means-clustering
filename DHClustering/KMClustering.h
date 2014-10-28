// Douglas Hill, October 2014
// https://github.com/douglashill/k-means-clustering

@import Foundation;

#import "KMCluster.h"
#import "KMVector.h"

/// Runs the k-means clustering algorithm `maxIterations` times. The objects in both `initialMeans` and `observationVectors` must conform to the `KMVector` protocol. Returns a set of `KMCluster`s.
NSSet *clustersWithInitialMeansAndObservations(NSSet *initialMeans, NSSet *observationVectors, NSUInteger maxIterations);
