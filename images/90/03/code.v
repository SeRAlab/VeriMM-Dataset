module top_module(
    input [3:0] bin_in,
    output [3:0] twos_comp_out
);assign twos_comp_out = ~bin_in + 4'b0001;

endmodule