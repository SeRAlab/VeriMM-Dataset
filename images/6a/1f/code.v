module top_module(
    input [1:0] A,
    input [1:0] B,
    output reg X
);wire C1 = A[0] & A[1];
    wire C2 = B[0] | B[1];

    always @(*) begin
        X = C1 ^ C2;
    end

endmodule