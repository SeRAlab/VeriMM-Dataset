module top_module(
    input [3:0] A,
    input [3:0] B,
    input clk,             // Added clk input
    output reg [7:0] P
);reg [3:0] A_reg, B_reg;
reg [7:0] P_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    P_reg <= A_reg * B_reg;
end

assign P = P_reg;

endmodule