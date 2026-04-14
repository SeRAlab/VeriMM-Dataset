module top_module(DATA0X0,DATA1X0,RESULT0);input DATA0X0; 
 input DATA1X0; 
 output RESULT0; 
 assign RESULT0 = DATA1X0 ^ DATA0X0; 
 endmodule