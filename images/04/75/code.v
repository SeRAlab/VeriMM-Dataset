module dwt_haar(
    input [3:0] signal_in,
    output [3:0] coeff_out
);
    assign coeff_out[0] = (signal_in[0] + signal_in[1]) >> 1; // Average
    assign coeff_out[1] = (signal_in[0] - signal_in[1]) >> 1; // Details
    assign coeff_out[2] = (signal_in[2] + signal_in[3]) >> 1; // Average
    assign coeff_out[3] = (signal_in[2] - signal_in[3]) >> 1; // Details
endmodule