module top_module(din, shamt, dout);input [15:0]din;
 input [3:0]shamt;
 output[15:0]dout;
 wire [15:0] t1,t2,t3,t4,t5;
 assign t1 = (shamt[3])?din>>8:din;
 assign t2 = (shamt[2])?t1>>4:t1;
 assign t3 = (shamt[1])?t2>>2:t2;
 assign t4 = (shamt[0])?t3>>1:t3;
 assign	dout = t4;

endmodule