module top_module(
    input clk,              // Added clk input
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] product
);reg [3:0] A_reg;
reg [3:0] B_reg;
reg [7:0] partial_product1;
reg [7:0] partial_product2;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    partial_product1 <= A_reg * B_reg;
end

always @(posedge clk) begin
    partial_product2 <= {partial_product1[3:0], 4'b0} + (A_reg * B_reg << 4);
    product <= partial_product2;
end

endmodule