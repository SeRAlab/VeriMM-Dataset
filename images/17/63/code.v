module carry_save_adder (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    output [3:0] sum,
    output carry_out
);
    wire [4:0] tmp_sum1, tmp_sum2;

    // First stage of addition: add a and b
    assign tmp_sum1 = a + b;

    // Second stage of addition: add the result with c
    assign tmp_sum2 = tmp_sum1 + c;

    // Final sum and carry out
    assign sum = tmp_sum2[3:0];
    assign carry_out = tmp_sum2[4];

endmodule