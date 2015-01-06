#ifndef __YAKUTO_H_
#define __YAKUTO_H_

#include <mach/mach_time.h>

void Y_LogFrameData();
void Y_RecordFrameStarted();
void Y_RecordUnityCompleted();
void Y_RecordUnityPlayerLoopFinished(uint64_t start);
double Y_ToMS(uint64_t t);
void Y_LogTouchesMoved();

#endif //__YAKUTO_H_
