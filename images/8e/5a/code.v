module top_module(out,input0,input1,select);input [4:0] input0,input1;
  
input select;
 
 output [4:0] out;
  
assign out = (select==1'b1) ? input1:input0;

endmodule