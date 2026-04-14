module dot_product (
    input [4:0] A,
    input [4:0] B,
    output reg [9:0] result
);

always @(*) begin
    result = (A[0] * B[0]) + (A[1] * B[1]) + (A[2] * B[2]) + (A[3] * B[3]) + (A[4] * B[4]);
end

endmodule