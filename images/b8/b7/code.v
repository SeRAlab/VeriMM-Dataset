module top_module(
    input [3:0] a,
    input [3:0] b,
    input clk,                // Added clock input
    output reg [7:0] product
);reg [3:0] a_reg, b_reg;
reg [7:0] product_reg;

always @(*) begin
    a_reg = a;
    b_reg = b;
end

always @(posedge clk) begin
    product_reg <= a_reg * b_reg;
end

assign product = product_reg;

endmodule