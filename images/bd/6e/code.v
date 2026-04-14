module top_module(
    input [3:0] bin_in,
    output [3:0] bcd_out_hi,
    output [3:0] bcd_out_lo
);wire [3:0] bin_out;
    assign bin_out = (bin_in >= 5) ? bin_in - 5 : bin_in;

    assign bcd_out_hi = (bin_in >= 5) ? 1'b1 : 1'b0;

    assign bcd_out_lo = (bin_out >= 5) ? bin_out - 4'b0101 : bin_out;

endmodule