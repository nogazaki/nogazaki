#include "main.h"
#include "DS1307.h"
#include "LibI2C.h"
#include "LibLCD.h"
#include "delay_ms.h"
#include "port.h"
#include "pushButton.h"
#include <REGX52.H>

void refAll();
void timeDisp();
void readButton();

unsigned char old_hour, old_min, old_sec, old_date, old_month, old_year, button, century = 20;
bit mode = 0;

void main() {
    // Khoi dong
    initLCD();
    offCursor();
    clrscr();
    I2C_Init();
    DS1307_Init();
    delay_ms(1000);

    DS1307_Read_Time(&hour, &min, &sec);
    DS1307_Read_Date(&day, &date, &month, &year);
    refAll();

    while (1) {
        timeDisp();
        readButton();
    }
}
// Cai dat cac gia tri v�o 1307
void timeSet() {
    unsigned char tmp;
    old_hour = !hour;
    old_min = !min;
    old_sec = !sec;
    old_date = !date;
    old_month = !month;
    old_year = !year * (year != 0);

    // Ngay lon nhat trong thang dua vao thang va nam
    tmp = (month == 2) ? ((year % 4) ? 28 : 29)
                       : ((((month % 2) && (month < 8)) || (!(month % 2) && (month > 7))) ? 31 : 30);
    if (date > tmp)
        date = tmp;

    DS1307_Write_Time(hour, min, sec);
    Ds1307_Write_Date(day, date, month, year);
}
void secDisp() // Hien thi giay
{
    gotoRowCol(0, (10 - (char)mode));
    outChar((sec / 10) + 48);
    outChar((sec % 10) + 48);
    if (!mode)
        outChar(' ');
}
void minDisp() // Hien thi phut
{
    gotoRowCol(0, (7 - (char)mode));
    outChar((min / 10) + 48);
    outChar((min % 10) + 48);
    outChar(':');
}
void hourDisp() // Hien thi gio
{
    unsigned char tmp;
    if (mode) {
        gotoRowCol(0, 11);
        if (hour > 11)
            outString("PM");
        else
            outString("AM");
    }
    tmp = hour - 12 * (char)(mode && hour > 12) + 12 * (char)(mode && hour == 00);
    gotoRowCol(0, (3 - (char)mode));
    outChar(' ');
    outChar((tmp / 10) + 48);
    outChar((tmp % 10) + 48);
    outChar(':');
}
void dateDisp() // Hien thi ngay
{
    gotoRowCol(1, 3);
    outChar((date / 10) + 48);
    outChar((date % 10) + 48);
    outChar('/');
}
void monthDisp() // Hien thi thang
{
    gotoRowCol(1, 6);
    outChar((month / 10) + 48);
    outChar((month % 10) + 48);
    outChar('/');
}
void yearDisp() // Hien thi nam
{
    gotoRowCol(1, 9);
    outChar((century / 10) + 48);
    outChar((century % 10) + 48);
    outChar((year / 10) + 48);
    outChar((year % 10) + 48);
}
void refAll() {
    hourDisp();
    minDisp();
    secDisp();
    dateDisp();
    monthDisp();
    yearDisp();
}
void timeDisp() {
    // Doc thoi gian tu 1307
    DS1307_Read_Time(&hour, &min, &sec);
    DS1307_Read_Date(&day, &date, &month, &year);

    // Cap nhat LCD, chi cap nhat cac gia tri co su thay doi
    if (old_sec != sec) {
        if (old_min != min) {
            if (old_hour != hour) {
                if (old_date != date) {
                    if (old_month != month) {
                        if (old_year != year) {
                            // if(year == 00) century++; //----Cap nhat the ki
                            old_year = year;
                            yearDisp();
                        }
                        old_month = month;
                        monthDisp();
                    }
                    old_date = date;
                    dateDisp();
                }
                old_hour = hour;
                hourDisp();
            }
            old_min = min;
            minDisp();
        }
        old_sec = sec;
        secDisp();
    }
}
void readButton() {
    button = pushButton();
    switch (button) {
    case 's': {
        while (button != 0)
            button = pushButton();
        settings(mode);
        refAll();
        break;
    }
    case 1: {
        break;
    }
    case 2: {
        while (button != 0)
            button = pushButton();
        mode = !mode;
        refAll();
        break;
    }
    case 3: {
        break;
    }
    case 4: {
        break;
    }
    default:
        break;
    }
}
