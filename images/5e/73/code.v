module top_module(in,vrefcode,vdd18);input vdd18; 
 input [7:1] in; 
 output [7:0] vrefcode; 
 assign vrefcode[7:0] = {in[7:1],1'b0}; 
 endmodule