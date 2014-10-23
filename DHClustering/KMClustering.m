// Douglas Hill, October 2014
// https://github.com/douglashill/DHClustering

#import "KMClustering.h"

#import "KMCluster.h"
#import "NSSet+DHMap.h"

/// Runs a single iteration of the k-means clustering algorithm.
static NSSet *clustersUpdatedWithObservations(NSSet *clusters, NSSet *observationVectors);

/// Repeat the block a given number of times.
static void repeat(NSUInteger repeatCount, void (^blockToRepeat)(BOOL *stop));

NSSet *clustersWithInitialMeansAndObservations(NSSet *initalMeans, NSSet *observationVectors, NSUInteger maxIterations)
{
	__block NSSet *clusters = [initalMeans dh_setByMappingObjectsUsingMap:^id(id <KMVector> mean) {
		return [KMCluster clusterWithMean:mean];
	}];
	
	repeat(maxIterations, ^(BOOL *stop) {
		NSSet *const oldClusters = clusters;
		clusters = clustersUpdatedWithObservations(clusters, observationVectors);
		
		NSString *const meanKey = NSStringFromSelector(@selector(mean));
		if ([[clusters valueForKey:meanKey] isEqualToSet:[oldClusters valueForKey:meanKey]]) {
			*stop = YES;
		}
	});
	
	return clusters;
}

static NSSet *clustersUpdatedWithObservations(NSSet *originalClusters, NSSet *observationVectors)
{
	NSSet *const clusters = [originalClusters dh_setByMappingObjectsUsingMap:^id (KMCluster *originalCluster) {
		return [KMCluster clusterWithMean:[originalCluster mean]];
	}];
	
	for (id <KMVector> observation in observationVectors) {
		// assign data points to cluster with nearest center
		
		double minimumDistance = HUGE;
		KMCluster *nearestCluster;
		
		for (KMCluster *cluster in clusters) {
			double const distance = [observation distanceFromVector:[cluster mean]];
			if (distance < minimumDistance) {
				minimumDistance = distance;
				nearestCluster = cluster;
			}
		}
		
		[nearestCluster addObservationVector:observation];
	}
	
	for (KMCluster *cluster in clusters) {
		[cluster updateMean];
	}
	
	return clusters;
}

static void repeat(NSUInteger repeatCount, void (^blockToRepeat)(BOOL *stop))
{
	if (blockToRepeat == nil) {
		return;
	}
	
	BOOL stop = NO;
	while (repeatCount--) {
		blockToRepeat(&stop);
		if (stop) break;
	}
}
