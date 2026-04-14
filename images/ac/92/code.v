module top_module(
   input [15:0] IN1,
   output [15:0] Y
);wire [15:0] and1, and2, and3, and4;
   wire [15:0] and5, and6, and7, and8;
   wire [15:0] and9, and10, and11, and12;
   wire [15:0] and13, and14, and15, and16;
   
   assign and1 = IN1[0] & IN1[1];
   assign and2 = IN1[2] & IN1[3];
   assign and3 = IN1[4] & IN1[5];
   assign and4 = IN1[6] & IN1[7];
   assign and5 = IN1[8] & IN1[9];
   assign and6 = IN1[10] & IN1[11];
   assign and7 = IN1[12] & IN1[13];
   assign and8 = IN1[14] & IN1[15];
   
   assign and9 = and1 & and2;
   assign and10 = and3 & and4;
   assign and11 = and5 & and6;
   assign and12 = and7 & and8;
   
   assign and13 = and9 & and10;
   assign and14 = and11 & and12;
   
   assign and15 = and13 & and14;
   
   assign Y = and15;

endmodule