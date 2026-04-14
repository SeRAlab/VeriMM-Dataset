module top_module(
    input clk,          // Added clk input
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] R
);reg [3:0] A_reg;
reg [3:0] B_reg;
reg [7:0] R_reg;

always @ (posedge clk) begin
    A_reg <= A;
    B_reg <= B;
end

always @ (posedge clk) begin
    R_reg <= A_reg * B_reg;
end

always @ (posedge clk) begin
    R <= R_reg;
end

endmodule