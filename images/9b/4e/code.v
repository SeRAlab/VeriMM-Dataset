module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    input clk,                   // Added clk input
    output [31:0] sum
);reg [31:0] a_reg, b_reg, sum_reg;
wire [31:0] add_out;

assign add_out = sub ? a_reg - b_reg : a_reg + b_reg;

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    sum_reg <= add_out;
end

assign sum = sum_reg;

endmodule