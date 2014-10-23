// Douglas Hill, October 2014
// https://github.com/douglashill/DHClustering

@import Foundation;
#import "KMVector.h"

@interface KMCluster : NSObject

/// Convenience. Calls initWithMean.
+ (instancetype)clusterWithMean:(id <KMVector>)initialMean;

/// Designated initialiser. The initial mean must not be nil.
- (instancetype)initWithMean:(id <KMVector>)initialMean __attribute((objc_designated_initializer));

@property (nonatomic, strong, readonly) id <KMVector> mean;

/// Recalculates `mean` from the observation vectors.
- (void)updateMean;

/// Does not change the mean until `updateMean` is called.
- (void)addObservationVector:(id <KMVector>)observation;

@end
