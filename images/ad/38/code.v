module top_module(output o, input s0, input [1:0] u0);assign o = s0 ? u0[0] : u0[1];
endmodule