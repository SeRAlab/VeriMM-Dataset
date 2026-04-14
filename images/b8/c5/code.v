module top_module(
    input [3:0] a,
    input [3:0] b,
    output [3:0] sum,
    output carry_out
);wire [3:0] sum_temp;
    wire carry_in;

    assign sum_temp = a + b;
    assign sum = sum_temp;
    assign carry_out = sum_temp[4];

endmodule