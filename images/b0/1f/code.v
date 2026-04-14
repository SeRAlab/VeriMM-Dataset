module top_module(
    a,
    b,
    en,
    sum,
    carry
);input [3:0] a;
    input [3:0] b;
    input en;
    output [3:0] sum;
    output carry;

    wire [3:0] temp_sum;
    wire [3:0] temp_carry;

    assign temp_sum = a + b;
    assign temp_carry = {a[3], b[3], temp_sum[3]} & 3'b100;

    assign sum = en ? temp_sum : 4'b0000;
    assign carry = en ? temp_carry[2] : 1'b0;

endmodule