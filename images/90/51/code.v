module top_module(
    input [31:0] a,
    input [31:0] b,
    input cin,
    output [31:0] sum,
    output cout
);wire [31:0] sum_temp;
    wire [31:0] carry_temp;

    assign sum_temp = a + b + cin;
    assign sum = sum_temp[31:0];
    assign carry_temp = {a[31], b[31], cin} + {sum_temp[31], {sum_temp[30:0]}};
    assign cout = carry_temp[2];

endmodule