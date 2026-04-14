module top_module(
    input signed [1:0] A,
    input signed [1:0] B,
    input clk,             // Added clk input
    output reg signed [3:0] P,
    output reg F
);reg signed [2:0] M;
reg signed [2:0] Q;      // Change to signed [2:0] for consistent size
reg signed [3:0] A_shifted;
reg signed [3:0] P_shifted;

always @(*) begin
    M = {B, 1'b0};         // Change to {B, 1'b0} for correct sizing
    Q = {A, 1'b0};         // Change to {A, 1'b0} for correct sizing
    A_shifted = {A, 2'b0};
    P_shifted = P;         // Assign current value of P instead of {P, 2'b0}
end

always @(posedge clk) begin
    if (Q[0] == 1 && Q[1] == 0) begin
        P_shifted = P_shifted - M;
        Q = {Q[1], Q[0], 1'b0};
    end
    else if (Q[0] == 0 && Q[1] == 1) begin
        P_shifted = P_shifted + M;
        Q = {Q[1], Q[0], 1'b0};
    end
    
    A_shifted = {A_shifted[2], A_shifted[3:1]}; // Correct shifting
    Q = {Q[1], Q[0], A_shifted[0]};
end

always @(*) begin
    P = P_shifted[3:0];
    F = (P_shifted[4] == 1 || P_shifted[5] == 1);
end

endmodule