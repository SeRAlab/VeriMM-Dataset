module top_module(clk,reset,loadseed_i,seed_i,number_o);input clk;
input reset;
input loadseed_i;
input [31:0] seed_i;
output [31:0] number_o;

reg [31:0]number_intern;
assign number_o = number_intern;
wire feedback = number_intern[31]^number_intern[21]^number_intern[1]^number_intern[0];

always @(posedge clk)
  if (reset) 
    number_intern <= 32'h0;
  else if (loadseed_i)
    number_intern <=seed_i;
  else
    number_intern <= {number_o[30:0], feedback} ;

endmodule