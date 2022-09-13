#ifndef _PUSH_BUTTON_H_
#define _PUSH_BUTTON_H_

unsigned char pushButton();
void settings(bit mode);
unsigned char delayAndCheck(unsigned int t);
void upButton(unsigned char *dat);
void downButton(unsigned char *dat);

#endif
