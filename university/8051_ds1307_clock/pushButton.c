#include "pushButton.h"
#include "LibLCD.h"
#include "delay_ms.h"
#include "main.h"
#include "port.h"
#include <REGX52.H>

unsigned char hour, min, sec, day, date, month, year, tmp;

//----Khai bao gia tri lon nhat cua ngay gio
unsigned char maxV[7] = {23, 59, 59, 'u', 31, 12, 99};
unsigned char minV[7] = {0, 0, 0, 'u', 1, 1, 0};
unsigned char posV[7] = {'u', 'u', 'u', 11, 3, 6, 9};
unsigned char sw;
unsigned char menu = 0;

unsigned char pushButton() {
    if (SET == 0 && MODE == 0)
        return 's';
    if (SET == 0)
        return 1;
    if (MODE == 0)
        return 2;
    if (UP == 0)
        return 3;
    if (DOWN == 0)
        return 4;
    return 0;
}
void settings(bit mode) {
    posV[0] = 4 - (char)mode;
    posV[1] = 7 - (char)mode;
    posV[2] = 10 - (char)mode;

    while (menu < 7) {
        // Nhat SET de dat gia tri va chuyen den cai dat gia tri tiep theo, khong quay lai
        while (sw != 1) {
            gotoRowCol((char)(menu > 3), posV[menu]);
            // Tao hieu ung nhap nhay
            if (menu == 6)
                outString("    ");
            else
                outString("  ");
            sw = delayAndCheck(500);

            switch (menu) {
            // Chinh gio
            case 0: {
                if (sw == 3)
                    upButton(&hour);
                if (sw == 4)
                    downButton(&hour);
                hourDisp();
                break;
            }
            // Chinh phut
            case 1: {
                if (sw == 3)
                    upButton(&min);
                if (sw == 4)
                    downButton(&min);
                minDisp();
                break;
            }
            // Chinh giay
            case 2: {
                if (sw == 3)
                    upButton(&sec);
                if (sw == 4)
                    downButton(&sec);
                secDisp();
                break;
            }
            // ampm, bo qua neu hien thi 24h
            case 3: {
                if (sw == 3 || sw == 4) {
                    while (sw != 0)
                        sw = pushButton();
                    hour += 12 * (char)(hour < 12) - 12 * (char)(hour > 11);
                }
                hourDisp();
                break;
            }
            // Chinh ngay
            case 4: {
                if (sw == 3)
                    upButton(&date);
                if (sw == 4)
                    downButton(&date);
                dateDisp();
                break;
            }
            // Chinh thang
            case 5: {
                if (sw == 3)
                    upButton(&month);
                if (sw == 4)
                    downButton(&month);
                monthDisp();
                break;
            }
            // Chinh nam
            case 6: {
                tmp = year;
                if (sw == 3)
                    upButton(&year);
                if (sw == 4)
                    downButton(&year);
                yearDisp();
                break;
            }
            default:
                break;
            }
            sw = delayAndCheck(500);
        }
        menu++;
        // Bo qua chinh buoi neu hien thi o che do 24h
        if (menu == 3 && !mode)
            menu++;
        while (sw != 0)
            sw = pushButton();
    }
    timeSet();
    menu = 0;
}
// Tao tre dong thoi kiem tra trang thai nut nhan
unsigned char delayAndCheck(unsigned int t) {
    unsigned char tmp;
    unsigned int x, y;
    for (x = 0; x < t; x++) {
        for (y = 0; y < 50; y++) {
            tmp = pushButton();
            if (tmp != 0)
                break;
        }
    }
    return tmp;
}
// Tang gia tri khi nhan UP
void upButton(unsigned char *dat) {
    while (sw != 0)
        sw = pushButton();
    if (*dat < maxV[menu])
        *dat = *dat + 1;
    else
        *dat = minV[menu];
}
// Giam gia tri khi nhan DOWN
void downButton(unsigned char *dat) {
    while (sw != 0)
        sw = pushButton();
    if (*dat > minV[menu])
        *dat = *dat - 1;
    else
        *dat = maxV[menu];
}
