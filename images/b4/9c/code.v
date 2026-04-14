module top_module(
    input clk, // Added clk input to resolve the error
    input a, b, c,
    output w, x, y, z
);reg a_reg, b_reg, c_reg;

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
    c_reg <= c;
end

assign w = a_reg;
assign x = b_reg;
assign y = b_reg;
assign z = c_reg;

endmodule