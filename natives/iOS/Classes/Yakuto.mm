#include "Yakuto.h"

uint Y_FrameCount;
uint64_t Y_LastTouchesMoved;
uint64_t Y_UnityLastFramePeriod;
uint64_t Y_UnityLastFrameTime;
uint64_t Y_UnityPlayerLoopDuration;


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

