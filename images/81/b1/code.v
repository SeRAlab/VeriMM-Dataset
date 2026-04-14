module top_module(
    input [3:0] binary_in,
    output reg [3:0] twos_comp_out
);assign twos_comp_out = (~binary_in) + 1;

endmodule