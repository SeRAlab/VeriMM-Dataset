module top_module(
    Y,
    A,
    B,
    mode,
    carry_out,
    overflow
);output [7:0] Y;
    input [7:0] A;
    input [7:0] B;
    input mode;
    output carry_out;
    output overflow;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire [8:0] temp_sum;
    wire [8:0] temp_diff;

    assign temp_sum = {1'b0, A} + {1'b0, B};
    assign temp_diff = {1'b0, A} - {1'b0, B};

    assign carry_out = temp_sum[8];
    assign overflow = (mode == 1) ? (temp_sum[8] ^ temp_sum[7]) : (temp_diff[8] ^ temp_diff[7]);

    assign Y = (mode == 1) ? temp_sum[7:0] : temp_diff[7:0];

endmodule