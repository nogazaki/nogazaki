#ifndef _MAIN_H_
#define _MAIN_H_

#include <REGX52.H>
#define FREQ_OSC 12000000

void timeSet();
void secDisp();
void minDisp();
void hourDisp();
void dateDisp();
void monthDisp();
void yearDisp();

extern unsigned char hour, min, sec , day, date, month, year;

#endif
