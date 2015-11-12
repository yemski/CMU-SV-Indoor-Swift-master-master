// IndoorAtlas iOS SDK
// IndoorAtlasCalibrator.h

#import <Foundation/Foundation.h>

/**
 * Enum defining all possible states of <IndoorAtlasBackgroundCalibratorDelegate> protocol.
 */
typedef NS_ENUM(NSInteger, IndoorAtlasBackgroundCalibratorState) {
    kIndoorAtlasBackgroundCalibratorStateStarted,
    kIndoorAtlasBackgroundCalibratorStateFailed,
    kIndoorAtlasBackgroundCalibratorStateReady,
};

/**
 * IndoorAtlasBackgroundCalibratorDelegate is the communication protocol for background calibrator.
 *
 * See the [calibration guide](../docs/2. Calibration.html) for an example how to use the background calibrator API.
 */
@protocol IndoorAtlasBackgroundCalibratorDelegate <NSObject>
@optional

/**
 * @name Communication
 */

/**
 * Report background calibration state change.
 *
 * @param state Result of the background calibration.
 *
 * Possible values are:
 *
 *    - kIndoorAtlasBackgroundCalibratorStatusStarted
 *
 *      Background calibration started.
 *
 *    - kIndoorAtlasBackgroundCalibratorStatusFailed
 *
 *      Background calibration failed. Calibration will restart immediately.
 *
 *    - kIndoorAtlasBackgroundCalibratorStatusReady
 *
 *      Background calibration is ready and can be used for positioning.
 */
- (void)indoorAtlasBackgroundCalibratorStateChanged:(IndoorAtlasBackgroundCalibratorState)state;

/**
 * Report background calibration progress.
 *
 * @param progress Background calibration progress (0..1).
 */
- (void)indoorAtlasBackgroundCalibratorProgress:(float)progress;

/**
 * @name Deprecated
 */

/**
 * Background calibrator started calibrating the device.
 *
 * @warning This method is removed, use <indoorAtlasBackgroundCalibratorStateChanged:> instead.
 */
- (void)indoorAtlasBackgroundCalibratorDidStartCalibrating __deprecated_msg("Use indoorAtlasBackgroundCalibratorStateChanged: instead");

/**
 * Background calibrator did finish calibration with status.
 *
 * @warning This method is removed, use <indoorAtlasBackgroundCalibratorStateChanged:> instead.
 *
 * @param failed If the status is failure (YES), the background calibrator will restart immediately.
 * If the status is success (NO), the background calibrator will stop and schedule restart until new calibration is needed.
 */
- (void)indoorAtlasBackgroundCalibratorDidFinishCalibratingWithStatus:(BOOL)failed __deprecated_msg("Use indoorAtlasBackgroundCalibratorStateChanged: instead");

@end

/**
 * Enum defining current calibration state.
 */
typedef NS_ENUM(NSInteger, IndoorAtlasCalibrationStatus) {
    /**
     * Calibrator has no calibration.
     */
    kIndoorAtlasCalibrationStatusNoCalibration,

    /**
     * Calibrator has old calibration.
     */
    kIndoorAtlasCalibrationStatusOldCalibration,

    /**
     * Calibrator has up-to-date calibration.
     */
    kIndoorAtlasCalibrationStatusReady,
};

/**
 * IndoorAtlasCalibrator provides the calibrator API for calibrating the device.
 *
 * See the [calibration guide](../docs/2. Calibration.html) for an example how to use the calibrator API.
 */
@interface IndoorAtlasCalibrator : NSObject

/**
 * @name Receiving background calibration events
 */

/**
 * Set background calibrator delegate.
 * There can be only single delegate listening to background calibrator events.
 *
 * When the delegate is set <[IndoorAtlasBackgroundCalibratorDelegate indoorAtlasBackgroundCalibratorStateChanged:]> will emit immediately with current state.
 *
 * @param delegate Instance that implements <IndoorAtlasBackgroundCalibratorDelegate>.
 */
+ (void)setBackgroundCalibratorDelegate:(id<IndoorAtlasBackgroundCalibratorDelegate>)delegate;

/**
 * @name Get calibration status
 */

/**
 * Get calibration status.
 *
 * - kIndoorAtlasCalibrationStatusNoCalibration
 *
 *   Calibrator has no calibration.
 *
 * - kIndoorAtlasCalibrationStatusOldCalibration
 *
 *   Calibrator has old calibration.
 *
 * - kIndoorAtlasCalibrationStatusReady
 *
 *   Calibrator has up-to-date calibration.
 */
@property (nonatomic, readonly) IndoorAtlasCalibrationStatus calibrationStatus;

/**
 * Check if calibrator instance is currently calibrating.
 */
@property (nonatomic, readonly) BOOL calibrating;

/**
 * @name Calibrating the device
 */

/**
 * Start forced calibration.
 *
 * See the [calibration guide](../docs/2. Calibration.html) for an example how to use the forced calibration.
 *
 * @param completionBlock A block to be called when the calibration task finishes.
 *
 *     - *error*: If an error occured, this object describes the error. If the operation completed successfully, this value is nil.
 *
 * @param progressBlock A block that is called each time calibration task progresses.
 *
 *     - *progress*: Progress of the calibration task (0..1)
 */
- (void)calibrate:(void (^)(NSError *error))completionBlock
         progress:(void (^)(float progress))progressBlock;

/**
 * Start explicit background calibration.
 *
 * See the [calibration guide](../docs/2. Calibration.html) for an example how to use the explicit background calibration.
 *
 * @param completionBlock A block to be called when the calibration task finishes.
 *
 *     - *error*: If an error occured, this object describes the error. If the operation completed successfully, this value is nil.
 *
 * @param progressBlock A block that is called each time calibration task progresses.
 *
 *     - *progress*: Progress of the calibration task (0..1)
 */
- (void)calibrateUsingBackgroundCalibrator:(void (^)(NSError *error))completionBlock
                                  progress:(void (^)(float progress))progressBlock;

/**
 * Cancel running explicit calibration.
 */
- (void)cancel;

@end

/* vim: set ts=8 sw=4 tw=0 ft=objc :*/
