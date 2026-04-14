module top_module(
    input clk,
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] S,
    output reg V
);reg [3:0] P1_S, P2_S, P3_S;
reg P1_C, P2_C, P3_C;

always @(posedge clk) begin
    // Pipeline stage 1
    P1_S <= A + B + Cin;
    P1_C <= (A[0] & B[0]) | ((A[0] | B[0]) & Cin);
    
    // Pipeline stage 2
    P2_S <= P1_S;
    P2_C <= (P1_S[0] & P1_C) | ((P1_S[0] | P1_C) & P1_S[1]);
    
    // Pipeline stage 3
    P3_S <= P2_S;
    P3_C <= (P2_S[1] & P2_C) | ((P2_S[1] | P2_C) & P2_S[2]);
    
    // Output stage
    S <= P3_S;
    V <= P3_C;
end

endmodule