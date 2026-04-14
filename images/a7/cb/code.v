module top_module(
 in,out   );input [3:0] in; 
output [1:0] out; 

assign out[0] = in[0] & in[1]; 
assign out[1] = in[2] | in[3];

endmodule