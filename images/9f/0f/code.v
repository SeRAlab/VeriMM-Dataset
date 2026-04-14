module top_module(src,regread0,regread1,regread2,regread3,dataout);input [1:0]src;
 input [3:0]regread0,regread1,regread2,regread3;
 output [3:0]dataout;
 assign dataout[0]=((~src[1])&(~src[0])&regread0[0])|((~src[1])&(src[0])&regread1[0])|((src[1])&(~src[0])&regread2[0])|((src[1])&(src[0])&regread3[0]);
 assign dataout[1]=((~src[1])&(~src[0])&regread0[1])|((~src[1])&(src[0])&regread1[1])|((src[1])&(~src[0])&regread2[1])|((src[1])&(src[0])&regread3[1]);
 assign dataout[2]=((~src[1])&(~src[0])&regread0[2])|((~src[1])&(src[0])&regread1[2])|((src[1])&(~src[0])&regread2[2])|((src[1])&(src[0])&regread3[2]);
 assign dataout[3]=((~src[1])&(~src[0])&regread0[3])|((~src[1])&(src[0])&regread1[3])|((src[1])&(~src[0])&regread2[3])|((src[1])&(src[0])&regread3[3]);
 
endmodule