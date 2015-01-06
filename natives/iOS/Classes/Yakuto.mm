#include "Yakuto.h"

uint64_t Y_LastTouchesMoved;


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

