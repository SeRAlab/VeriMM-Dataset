module top_module(
    input signed [15:0] M,
    input signed [15:0] N,
    input clk,                   // Added clk input
    output reg signed [31:0] P
);reg signed [15:0] M_reg;
reg signed [15:0] N_reg;
reg signed [31:0] P_reg;

always @(posedge clk) begin
    M_reg <= M;
    N_reg <= N;
end

always @(posedge clk) begin
    P_reg <= M_reg * N_reg;
end

assign P = P_reg;

endmodule