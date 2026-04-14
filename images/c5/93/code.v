module adder (
    input [7:0] A,
    input [7:0] B,
    output [7:0] sum,
    output carry_out
);

    wire [8:0] temp_sum;
    assign temp_sum = A + B;
    assign carry_out = temp_sum[8];
    assign sum = temp_sum[7:0];

endmodule