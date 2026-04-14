module top_module(
    A,
    B,
    sum,
    carry_out
);input [3:0] A;
    input [3:0] B;
    output [3:0] sum;
    output carry_out;

    wire [3:0] carry; // intermediate carry signals

    assign sum = A + B;
    assign carry = (A & B) | ((A | B) & ~sum);
    assign carry_out = carry[3];

endmodule