module top_module(
    input clk,
    input a,
    input b,
    output reg out
);reg a_reg, b_reg;
reg xor_out_reg;

always @(posedge clk) begin
    a_reg <= a;
    b_reg <= b;
end

assign xor_out = a_reg ^ b_reg;

always @(posedge clk) begin
    xor_out_reg <= xor_out;
end

assign out = xor_out_reg;

endmodule