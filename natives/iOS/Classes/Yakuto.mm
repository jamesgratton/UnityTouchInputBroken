#include "Yakuto.h"

uint Y_FrameCount;
uint64_t Y_LastTouchesMoved;
uint64_t Y_LastRunLoopObserverTime;
uint64_t Y_UnityLastFramePeriod;
uint64_t Y_UnityLastFrameTime;
uint64_t Y_UnityPlayerLoopDuration;


void Y_RunLoopObserverHandler(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void* info)
{
    uint64_t now = mach_absolute_time();
    double elapsed = Y_ToMS(now - Y_LastRunLoopObserverTime);
    Y_LastRunLoopObserverTime = now;


    NSString *s;

    switch (activity)
    {
        case kCFRunLoopEntry:         s = @"   1  Entry"; break;
        case kCFRunLoopBeforeTimers:  s = @"   2  Before Timers"; break;
        case kCFRunLoopBeforeSources: s = @"   4  Before Sources"; break;
        case kCFRunLoopBeforeWaiting: s = @"  32  Before Waiting"; break;
        case kCFRunLoopAfterWaiting:  s = @"  64  After  Waiting"; break;
        case kCFRunLoopExit:          s = @" 128  Exit"; break;
        default: s = [NSString stringWithFormat:@"%d  Unknown", (int) activity];
    }

    NSLog(@"%.2f \t %@\n", elapsed, s);
}

void Y_LogFrameData() {
    NSLog(@"Frame: %d \t\t Period: %.2f \t\t UPL: %.2f"
            , Y_FrameCount
            , Y_ToMS(Y_UnityLastFramePeriod)
            , Y_ToMS(Y_UnityPlayerLoopDuration));
}

void Y_RecordFrameStarted() {
    Y_FrameCount++;
}

void Y_RecordUnityCompleted() {
    uint64_t now = mach_absolute_time();

    Y_UnityLastFramePeriod = now - Y_UnityLastFrameTime;

    Y_UnityLastFrameTime = now;
}

void Y_RecordUnityPlayerLoopFinished(uint64_t start) {
    Y_UnityPlayerLoopDuration = mach_absolute_time() - start;
}

void Y_RegisterRunLoopObserver() {

//     1  kCFRunLoopEntry = (1UL << 0),
//     2  kCFRunLoopBeforeTimers = (1UL << 1),
//     4  kCFRunLoopBeforeSources = (1UL << 2),
//    32  kCFRunLoopBeforeWaiting = (1UL << 5),
//    64  kCFRunLoopAfterWaiting = (1UL << 6),
//   128  kCFRunLoopExit = (1UL << 7),
//        kCFRunLoopAllActivities = 0x0FFFFFFFU

    CFRunLoopObserverRef myObserver = NULL;
    CFOptionFlags myActivities = kCFRunLoopAllActivities;

    myObserver = CFRunLoopObserverCreate(NULL,
            myActivities,
            YES,
            0,
            &Y_RunLoopObserverHandler,
            NULL);

    if (myObserver)
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), myObserver, kCFRunLoopCommonModes);
}

double Y_ToMS(uint64_t t) {
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);

    t *= info.numer;
    t /= info.denom;

    return t / 1000000.0;
}

void Y_LogTouchesMoved() {
    uint64_t now = mach_absolute_time();
    double period = Y_ToMS(now - Y_LastTouchesMoved);
    Y_LastTouchesMoved = now;

    NSLog(@"> touch period: %.2f\n", period);
}

