#line 1 "D:/Projects/Embedded/Code/MY__CODE.c"


int i = 0 ,mode = 0 , curr_mode=0;
int nums[] = {0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x18,0x19,0x20,0x21,0x22,0x23};
void manual_mode();
void auto_mode();
void interrupt(){
 if( intf_bit ){
  intf_bit  = 0 ;
 mode = !mode;
 }
}
void main() {
 trisb= 0b00000011;
 trisc = 0 ;
 trisd = 0 ;
 portc = 0 ; portd = 0 ;
 gie_bit = 1 ; inte_bit = 1 ;

 while(1){
 if(mode) auto_mode();
 else manual_mode();
 }
}
void auto_mode(){
 portd = 0; portc = 0b1100000;
 curr_mode = mode;
 for(i=15; i>=0 ; i--){
 if (curr_mode!=mode) break;
 portd = nums[i] ;
 if(i>12) portc = 0b11010001 ;
 else portc = 0b11100001 ;
 delay_ms(1000) ;
 }
 for(i=23;i>=0; i--){
 if(curr_mode!=mode) break;
 portd = nums[i];
 if (i>20) portc = 0b11001010 ;
 else portc = 0b11001100;
 delay_ms(1000);
 }
 }
void manual_mode(){
 curr_mode = mode;
 for(i=3;i>=0;i--) {
 portd = nums[i];
 portc = 0b01010001;
 if(i)delay_ms(1000);
 }
 if(curr_mode!=mode) return ;
 while(! portb.b1  && curr_mode == mode)portc = 0b00100001;
 if(curr_mode!=mode) return ;
 for(i=3;i>=0 ; i--){
 portd = nums[i];
 portc = 0b10001010;
 if(i) delay_ms(1000);
 }
 if (curr_mode!=mode) return;
 while(! portb.b1  && curr_mode == mode) portc = 0b00001100;
 if(curr_mode!=mode) return ;
}
