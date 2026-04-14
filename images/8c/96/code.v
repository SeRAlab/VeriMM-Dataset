module top_module( input [7:0] in, output reg [7:0] out);assign out = {in[7], 7'b1111111}; 
endmodule