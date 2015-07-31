// Douglas Hill, October 2014
// https://github.com/douglashill/k-means-clustering

@import Foundation;
#import "KMVector.h"

NS_ASSUME_NONNULL_BEGIN

@interface KMCluster : NSObject

/// Convenience. Calls initWithMean.
+ (instancetype)clusterWithMean:(id<KMVector>)initialMean;

/// Designated initialiser. The initial mean must not be nil.
- (instancetype)initWithMean:(id<KMVector>)initialMean NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) id<KMVector> mean;

/// Recalculates `mean` from the observation vectors.
- (void)updateMean;

@property (nonatomic, strong, readonly) NSSet<id<KMVector>> *observationVectors;

/// Does not change the mean until `updateMean` is called.
- (void)addObservationVector:(id<KMVector>)observation;

@end

NS_ASSUME_NONNULL_END
