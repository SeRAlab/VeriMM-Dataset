module binary_adder(
    input [3:0] A,
    input [3:0] B,
    input C,
    output [3:0] Z
);

    wire [3:0] A_comp, B_comp;
    wire [4:0] sum;
    wire carry;

    assign A_comp = (~A) + 1;
    assign B_comp = (~B) + 1;

    assign sum = A_comp + B_comp + C;

    assign carry = sum[4];

    assign Z = (C) ? (~sum[3:0] + 1) : sum[3:0];

endmodule