module top_module(input [15:0] extend_in,output [31:0] extend_out);assign extend_out=extend_in[15]?
                                  {16'b1111111111111111,extend_in}:
                                  {16'b0,extend_in};endmodule