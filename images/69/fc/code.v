module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] S,
    output reg C_OUT
);reg [3:0] C;

always @(*) begin
    S = A + B + C;
    C_OUT = (S[3] == 1) ? 1 : 0;
end

// Ripple carry logic
integer i;
always @(*) begin
    C[0] = 0;
    for (i = 1; i < 4; i = i + 1) begin
        C[i] = (A[i-1] & B[i-1]) | (A[i-1] & C[i-1]) | (B[i-1] & C[i-1]);
    end
end

endmodule