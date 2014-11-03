// Douglas Hill, October 2014
// https://github.com/douglashill/k-means-clustering

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
		
		// This does not seem to work, and is not the proper way to determine convergence.
		NSString *const meanKey = NSStringFromSelector(@selector(mean));
		if ([[clusters valueForKey:meanKey] isEqualToSet:[oldClusters valueForKey:meanKey]]) {
			*stop = YES;
		}
	});
	
	return clusters;
}

static NSSet *clustersUpdatedWithObservations(NSSet *originalClusters, NSSet *observationVectors)
{
	CFAbsoluteTime const startTime = CACurrentMediaTime();
	
	static NSUInteger const numberOfConcurrentOperations = 2;
	
	NSSet *const multiClusters = [originalClusters dh_setByMappingObjectsUsingMap:^id (KMCluster *originalCluster) {
		
		NSMutableArray *multiCluster = [NSMutableArray arrayWithCapacity:numberOfConcurrentOperations];
		repeat(numberOfConcurrentOperations, ^(BOOL *stop) {
			[multiCluster addObject:[KMCluster clusterWithMean:[originalCluster mean]]];
		});
		
		return multiCluster;
	}];
	
	NSArray *const observationVectorsArray = [observationVectors allObjects];
	NSUInteger const observationCount = [observationVectorsArray count];
	
	CFAbsoluteTime const mapTime = CACurrentMediaTime();
	
	dispatch_group_t const group = dispatch_group_create();
	
	for (NSUInteger concurrencyIndex = 0; concurrencyIndex < numberOfConcurrentOperations; ++concurrencyIndex) {
		
		dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
			for (NSUInteger observationIndex = concurrencyIndex; observationIndex < observationCount; observationIndex += numberOfConcurrentOperations) {
				
				id <KMVector> observation = observationVectorsArray[observationIndex];
				
				// assign data points to cluster with nearest center
				
				double minimumDistance = HUGE;
				KMCluster *nearestCluster;
				
				for (NSArray *multiCluster in multiClusters) {
					
					KMCluster *const cluster = multiCluster[concurrencyIndex];
					
					double const distance = [observation distanceFromVector:[cluster mean]];
					if (distance < minimumDistance) {
						minimumDistance = distance;
						nearestCluster = cluster;
					}
				}
				
				[nearestCluster addObservationVector:observation];
				
			}
		});
	}
	
	dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
	
	CFAbsoluteTime const closestMeansTime = CACurrentMediaTime();
	
	// Combine each multi-cluster
	NSSet *const clusters = [multiClusters dh_setByMappingObjectsUsingMap:^id (NSArray *multiCluster) {
		
		KMCluster *const combinedCluster = [[KMCluster alloc] init];
		
		for (KMCluster *cluster in multiCluster) {
			for (id <KMVector> observation in [cluster observationVectors]) {
				[combinedCluster addObservationVector:observation];
			}
		}
		
		return combinedCluster;
	}];
	
	CFAbsoluteTime const combineTime = CACurrentMediaTime();
	
	[clusters enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(KMCluster *cluster, BOOL *stop) {
		[cluster updateMean];
	}];
	
	CFAbsoluteTime const updateMeansTime = CACurrentMediaTime();
	
	NSLog(@"Time to run: %.2fms • %.2fms • %.2fms • %.2fms", 1000 * (mapTime - startTime), 1000 * (closestMeansTime - mapTime), 1000 * (combineTime - closestMeansTime), 1000 * (updateMeansTime - combineTime));
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
