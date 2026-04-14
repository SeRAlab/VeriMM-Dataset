module top_module(
    input clk,
    input reset,
    input [3:0] a, b,
    output reg [7:0] product
);reg [3:0] a_reg, b_reg;
reg [7:0] product_reg;

always @(posedge clk) begin
    if (reset) begin
        product_reg <= 8'b0;
        a_reg <= 4'b0;
        b_reg <= 4'b0;
    end else begin
        a_reg <= a;
        b_reg <= b;
        product_reg <= product_reg + (a_reg & 1'b1 ? b_reg : 0);
        a_reg <= a_reg >> 1;
        b_reg <= b_reg << 1;
    end
end

assign product = product_reg;

endmodule