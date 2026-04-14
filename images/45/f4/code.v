module top_module(
    A,
    B,
    C
);input [3:0] A;
    input [3:0] B;
    output [4:0] C;

    wire [3:0] sum;
    wire overflow;

    assign sum = A + B;

    assign overflow = ((A[3] & B[3]) | (A[3] & ~sum[3]) | (B[3] & ~sum[3]));

    assign C = {overflow, sum};

endmodule