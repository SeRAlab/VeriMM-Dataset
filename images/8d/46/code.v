module top_module(input [15:0] i,output [3:0] o3,output [3:0] o2,output [3:0] o1,output [3:0] o0);assign o3 = i[15:12]; 
  assign o2 = i[11:8]; 
  assign o1 = i[7:4]; 
  assign o0 = i[3:0]; 
 endmodule