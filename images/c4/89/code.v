module four_bit_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C
);

    wire [3:0] sum;
    assign sum = A + B;

    assign S = sum;
    assign C = (sum[4] == 1);

endmodule