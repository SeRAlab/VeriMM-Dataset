module top_module(
    input clk,  // Added clk as an input
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output [3:0] SUM
);reg [3:0] A_reg, B_reg, SUM_reg;
reg SUB_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    SUB_reg <= SUB;
end

always @(posedge clk) begin
    if (SUB_reg == 1'b0) begin
        SUM_reg <= A_reg + B_reg;
    end else begin
        SUM_reg <= A_reg - B_reg;
    end
end

assign SUM = SUM_reg;

endmodule