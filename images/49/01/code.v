module top_module(input BAout, input [31:0] Zeros, R0_in, output [31:0] R0Mux_out);assign R0Mux_out = BAout ? Zeros: R0_in;

endmodule