// Douglas Hill, October 2014
// https://github.com/douglashill/k-means-clustering

#import "KMCluster.h"

@interface KMCluster ()

@property (nonatomic, strong) id <KMVector> mean;
@property (nonatomic, strong, readonly) NSMutableSet *mutableObservationVectors;

@end

@implementation KMCluster

+ (instancetype)clusterWithMean:(id <KMVector>)initialMean
{
	return [[self alloc] initWithMean:initialMean];
}

- (instancetype)init
{
	return [self initWithMean:nil];
}

- (instancetype)initWithMean:(id <KMVector>)initialMean
{
	self = [super init];
	if (self == nil) return nil;
	
	_mean = initialMean;
	_mutableObservationVectors = [NSMutableSet set];
	
	return self;
}

- (void)updateMean
{
	if ([[self observationVectors] count] == 0) {
		return;
	}
	
	id <KMVector> newMean = [[[[self observationVectors] anyObject] class] meanOfVectors:[self observationVectors]];
	
	if (newMean == nil) {
		[NSException raise:NSInternalInconsistencyException format:@"meanOfVectors: must not return nil unless there are no observation vectors."];
	}
	
	[self setMean:newMean];
}

- (NSSet *)observationVectors
{
	return [self mutableObservationVectors];
}

- (void)addObservationVector:(id <KMVector>)observation
{
	[[self mutableObservationVectors] addObject:observation];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@, Mean: %@, Observations: %@", [super description], [self mean], [self observationVectors]];
}

@end
