module parallel_adder (
    input [3:0] A,
    input [3:0] B,
    input carry_in,
    output [3:0] sum,
    output carry_out
);

    assign {carry_out, sum} = A + B + carry_in;

endmodule