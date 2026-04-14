module top_module(
    input clk,      // Added the clk input
    input a,
    input b,
    output reg out
);reg a_reg, b_reg;

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
end

always @(posedge clk) begin
    out <= a_reg ^ b_reg;
end

endmodule