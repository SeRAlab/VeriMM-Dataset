module top_module(
    input wire [2:0] binary_in,
    output wire [2:0] binary_out,
    output wire bit2_out,
    output wire bit1_out,
    output wire bit0_out
);assign binary_out = binary_in;
assign bit2_out = binary_in[2];
assign bit1_out = binary_in[1];
assign bit0_out = binary_in[0];

endmodule