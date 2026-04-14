module top_module(
    input [1:0] A,
    input [1:0] B,
    output reg [1:0] EQ,
    output reg [1:0] GT
);// EQ calculation
    assign EQ[1] = ~(A[1] ^ B[1]);
    assign EQ[0] = ~(A[0] ^ B[0]);

    // GT calculation
    always @(*) begin
        if (A[1] > B[1])
            GT[1] = 1;
        else
            GT[1] = 0;

        if (A[0] > B[0])
            GT[0] = 1;
        else
            GT[0] = 0;
    end

endmodule