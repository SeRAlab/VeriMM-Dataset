module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,
    output reg [3:0] S,
    output reg C_OUT
);reg [3:0] P1_S, P2_S, P3_S;
reg P1_C, P2_C, P3_C;

// Pipeline stage 1
always @(posedge clk) begin
    P1_S <= A + B;
    P1_C <= (A[3] & B[3]) | (A[3] & P1_S[3]) | (B[3] & P1_S[3]);
end

// Pipeline stage 2
always @(posedge clk) begin
    P2_S <= P1_S;
    P2_C <= (A[2] & B[2]) | (A[2] & P2_S[2]) | (B[2] & P2_S[2]) | (P1_C & P1_S[3]);
end

// Pipeline stage 3
always @(posedge clk) begin
    P3_S <= P2_S;
    P3_C <= (A[1] & B[1]) | (A[1] & P3_S[1]) | (B[1] & P3_S[1]) | (P2_C & P2_S[2]);
end

// Output stage
always @(posedge clk) begin
    S <= P3_S;
    C_OUT <= (A[0] & B[0]) | (A[0] & S[0]) | (B[0] & S[0]) | (P3_C & P3_S[1]);
end

endmodule