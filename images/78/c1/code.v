module top_module(
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output reg [3:0] S,
    output reg COUT
);always @(*) begin
        S = A + B + CIN;
        COUT = (A[3] & B[3]) | (A[3] & CIN) | (B[3] & CIN);
    end

endmodule