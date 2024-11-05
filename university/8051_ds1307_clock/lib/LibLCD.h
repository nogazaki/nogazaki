#ifndef __LIBLCD_H__
#define __LIBLCD_H__

void initLCD();
void outCmd(char cmd);
void outChar( char c);
void gotoRowCol( unsigned int row, unsigned int col);
void outString(char *s);
void offCursor();
void clrscr();

#endif
