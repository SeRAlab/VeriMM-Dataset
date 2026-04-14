module top_module(
    input clk,
    input [31:0] a,
    input [31:0] b,
    output [63:0] p
);reg [31:0] a_reg;
reg [31:0] b_reg;
reg [63:0] p_reg;

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    p_reg <= a_reg * b_reg;
end

assign p = p_reg;

endmodule