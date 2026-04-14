module top_module( A_IN, B_IN, CY_IN, SUBP, OUT, CY_OUT );input [3:0] A_IN,B_IN; 
  input CY_IN; 
  input SUBP; 
  output [3:0] OUT; 
  output CY_OUT; 
  wire [4:0] result; 
  wire over; 
  assign result = SUBP ? ({1'b0,A_IN} - {1'b0,B_IN} - {4'b0,CY_IN}) 
  : ({1'b0,A_IN} + {1'b0,B_IN} + {4'b0,CY_IN}); 
  assign over = result[4] | (result[3] & (result[2] | result[1])); 
  assign OUT = result[3:0] - (SUBP ? {1'b0,result[4],result[4],1'b0} : {over,1'b0,over,1'b0}); 
  assign CY_OUT = SUBP ? result[4] : over; 
 endmodule