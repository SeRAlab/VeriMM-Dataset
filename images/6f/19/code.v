module top_module(
    input [3:0] bin_in,
    output [15:0] dec_out
    );assign dec_out = bin_in[0] * 2**0 + bin_in[1] * 2**1 + bin_in[2] * 2**2 + bin_in[3] * 2**3;
  
endmodule