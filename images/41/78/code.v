module top_module(
    input signed [31:0] A,
    input signed [31:0] B,
    input C,
    output signed [31:0] S,
    output V
);wire [31:0] notB;
    wire [31:0] carryIn;
    wire [31:0] carryOut;
    wire [31:0] sum;
    wire [31:0] notSum;
    wire overflow;

    assign notB = ~B;
    assign carryIn = {32{C}};
    assign {carryOut, sum} = A + notB + carryIn;
    assign notSum = ~sum;
    assign overflow = (A[31] == B[31] && A[31] != sum[31]) ? 1 : 0;

    assign S = (C == 1) ? sum : (notSum + 1);
    assign V = overflow;

endmodule