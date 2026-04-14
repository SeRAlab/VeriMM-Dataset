module array_multiplier (
    input [3:0] A,
    input [3:0] B,
    output [7:0] product
);
    wire [3:0] p0, p1, p2, p3;
    wire [7:0] sum1, sum2, sum3;

    assign p0 = A & {4{B[0]}};
    assign p1 = A & {4{B[1]}};
    assign p2 = A & {4{B[2]}};
    assign p3 = A & {4{B[3]}};

    assign sum1 = {4'b0000, p1} + {3'b000, p2, 1'b0} + {2'b00, p3, 2'b00};
    assign product = {sum1[7:4], p0} + sum1;

endmodule