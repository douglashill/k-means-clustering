// Douglas Hill, October 2014
// https://github.com/douglashill/k-means-clustering

#import "KMClustering.h"

#import "KMCluster.h"
#import "NSSet+DHMap.h"

/// Runs a single iteration of the k-means clustering algorithm.
static NSSet<KMCluster *> *clustersUpdatedWithObservations(NSSet<KMCluster *> *clusters, NSSet<id<KMVector>> *observationVectors);

/// Repeat the block a given number of times.
static void repeat(NSUInteger repeatCount, void (^blockToRepeat)(BOOL *stop));

NSSet<KMCluster *> *clustersWithInitialMeansAndObservations(NSSet<id<KMVector>> *initialMeans, NSSet<id<KMVector>> *observationVectors, NSUInteger maxIterations)
{
	__block NSSet *clusters = [initialMeans dh_setByMappingObjectsUsingMap:^id (id<KMVector> mean) {
		return [KMCluster clusterWithMean:mean];
	}];
	
	repeat(maxIterations, ^(BOOL *stop) {
		NSSet *const oldClusters = clusters;
		clusters = clustersUpdatedWithObservations(clusters, observationVectors);
		
		// This does not seem to work, and is not the proper way to determine convergence.
		NSString *const meanKey = NSStringFromSelector(@selector(mean));
		if ([[clusters valueForKey:meanKey] isEqualToSet:[oldClusters valueForKey:meanKey]]) {
			*stop = YES;
		}
	});
	
	return clusters;
}

static NSSet<KMCluster *> *clustersUpdatedWithObservations(NSSet<KMCluster *> *originalClusters, NSSet<id<KMVector>> *observationVectors)
{
	CFAbsoluteTime startTime = CACurrentMediaTime();
	
	NSSet<KMCluster *> *const clusters = [originalClusters dh_setByMappingObjectsUsingMap:^id (KMCluster *originalCluster) {
		return [KMCluster clusterWithMean:[originalCluster mean]];
	}];
	
	for (id<KMVector> observation in observationVectors) {
		// assign data points to cluster with nearest center
		
		float minimumDistance = MAXFLOAT;
		KMCluster *nearestCluster;
		
		for (KMCluster *cluster in clusters) {
			float const distance = [observation distanceFromVector:[cluster mean]];
			if (distance < minimumDistance) {
				minimumDistance = distance;
				nearestCluster = cluster;
			}
		}
		
		[nearestCluster addObservationVector:observation];
	}
	
	[clusters enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(KMCluster *cluster, BOOL *stop) {
		[cluster updateMean];
	}];
	
	NSLog(@"Time to run: %.2fms", 1000 * (CACurrentMediaTime() - startTime));
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
