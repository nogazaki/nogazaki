#include "LibI2C.h"
#include "port.h"
#include <REGX52.H>

// Ports:
//    I2C_SDA
//    I2C_SCL

// Khai bao cac ham su dung noi bo:
bit I2C_GetACK();
void I2C_CreACK();
void I2C_CreNAK();
void I2C_Delay();
//=======I2C_GetACK (fromSlave)=======
// Decription: Sau khi Slave nhan duoc 1byte tu Master, Slave se bao lai cho Master bang cach keo SDA = 0
//                        Ham nay muc dich la kiem tra xem Slave co keo chan SDA xuong hay khong
// Tra ve 0 la ACK, 1 la NAK
bit I2C_GetACK() {
    bit ack;
    I2C_SDA = 1; // Keo SDA = 1 truoc, neu Slave nhan duoc byte thi no tu keo xuong 0.
    I2C_Delay();
    I2C_SCL = 1;
    I2C_Delay();
    ack = I2C_SDA;
    I2C_SCL = 0;
    return ack;
}
//=======I2C_CreACK (fromMaster)=======
// Decription: Sau khi nhan 1byte tu Slave, Master phai bao cho Slave bang 1bit ACK hay NAK
//                        Ham nay muc dich Master tao ACK gui lai cho Slave bang cach keo SDA
// xuong muc thap
void I2C_CreACK() {
    I2C_SDA = 0;
    I2C_Delay();
    I2C_SCL = 1;
    I2C_Delay();
    I2C_SCL = 0;
}
//=======I2C_CreNAK (fromMaster)=======
// Decription: Sau khi nhan 1byte tu Slave, Master phai bao cho Slave bang 1bit ACK hay NAK
//                        Ham nay muc dich Master tao NAK gui lai cho Slave bang cach keo SDA
// xuong muc thap                         Sau khi gui NAK thi Master phai tao lenh STOP
void I2C_CreNAK() {
    I2C_SDA = 1;
    I2C_Delay();
    I2C_SCL = 1;
    I2C_Delay();
    I2C_SCL = 0;
}
//========I2C Delay =========
void I2C_Delay() {
    char i = 5;
    while (i)
        i--;
}
//========I2C Init ==========
// Description: Khoi tao giao tiep I2C
void I2C_Init() {
    I2C_SDA = 1;
    I2C_SCL = 1;
}
//======== I2C Start ========
// Decription: Trong khi SCL = 1, thi co 1 su chuyen doi SDA tu 1 -> 0
void I2C_Start() {
    I2C_SDA = 1;
    I2C_Delay();
    I2C_SCL = 1;
    I2C_Delay();
    I2C_SDA = 0;
    I2C_Delay();
    I2C_SCL = 0;
}
//========= I2C Stop ========
// Decription: Trong khi SCL = 1, thi co 1 su chuyen doi SDA tu 0 -> 1
void I2C_Stop() {
    I2C_SDA = 0;
    I2C_Delay();
    I2C_SCL = 1;
    I2C_Delay();
    I2C_SDA = 1;
    I2C_Delay();
    I2C_SCL = 0;
}
//=======I2C_Write (send byte from Master -> Slave) ============
// Description: Gui 1 byte tu Master sang Slave
//                            Sau khi gui, ham se tra ve 1bit thong bao xem Slave da nhan duoc
// hay chua
bit I2C_Write(unsigned char dat) {
    unsigned char i;
    for (i = 0; i < 8; i++) {
        I2C_SDA = (bit)(dat & 10000000);
        I2C_Delay();
        I2C_SCL = 1;
        I2C_Delay();
        I2C_SCL = 0;
        dat <<= 1;
    }
    return I2C_GetACK();
}
//=======I2C_Read (send byte from Slave -> Master) ============
unsigned char I2C_Read(bit ack) {
    unsigned char i, buffer = 0;
    for (i = 0; i < 8; i++) {
        buffer <<= 1;
        I2C_SDA =
            1; // Ban dau keo SDA len 1 truoc, roi sau khi co xung clock thi Slave tu keo SDA xuong 0 hoac giu nguyen
        I2C_Delay();
        I2C_SCL = 1;
        I2C_Delay();
        if (I2C_SDA)
            buffer |= 0x01; // Gop cac bit lai thanh 1 byte
        I2C_SCL = 0;
    }
    if (ack)
        I2C_CreACK();
    else
        I2C_CreNAK();
    return buffer;
}
