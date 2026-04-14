module top_module( state_in, key, state_out);input [0:127] state_in;
 input [0:127] key;

 output [0:127] state_out;


 

 

assign state_out = (state_in ^ key);endmodule