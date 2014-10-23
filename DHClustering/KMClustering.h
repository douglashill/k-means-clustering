// Douglas Hill, October 2014
// https://github.com/douglashill/DHClustering

@import Foundation;

#import "KMVector.h"

/// Runs the k-means clustering algorithm until convergence or `maxIterations` is reached. The objects in both `initialMeans` and `observationVectors` must conform to the `KMVector` protocol.
NSSet *clustersWithInitialMeansAndObservations(NSSet *initialMeans, NSSet *observationVectors, NSUInteger maxIterations);
