module top_module(input [14:0] i,output [4:0] o1,output [9:0] o0);assign o1 = i[14:10]; 
  assign o0 = i[9:0]; 
 endmodule