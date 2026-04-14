module top_module(
    input wire clk,
    input wire reset,
    input wire [7:0] binary_in,
    output wire [9:0] bcd_out
);wire [2:0] bcd_hundreds;
    wire [3:0] bcd_tens;
    wire [3:0] bcd_ones;

    assign bcd_hundreds = {
        binary_in[7],
        binary_in[6],
        binary_in[5]
    };

    assign bcd_tens = {binary_in[4], 3'b0} + (binary_in[4] ? 4'd10 : 4'd0);

    assign bcd_ones = {binary_in[3], 3'b0} + (binary_in[3] ? 4'd10 : 4'd0);

    assign bcd_out = {bcd_hundreds, bcd_tens, bcd_ones};

endmodule