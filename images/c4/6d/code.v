module addition_module(
    input [7:0] A,
    input [7:0] B,
    output [8:0] sum,
    output carry
);

    wire [8:0] temp_sum;
    assign temp_sum = A + B;
    assign carry = (temp_sum[8] == 1) ? 1 : 0;
    assign sum = temp_sum;

endmodule