module top_module(
    input clk,              // Add clk input
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);reg [3:0] in_reg1, in_reg2, in_reg3;
reg and_reg, or_reg, xor_reg; // Change sizes to match output

always @(posedge clk) begin
    in_reg1 <= in;
    in_reg2 <= in_reg1;
    in_reg3 <= in_reg2;
    and_reg <= in_reg1[0] & in_reg2[1] & in_reg3[2];
    or_reg <= in_reg1[0] | in_reg2[1] | in_reg3[2];
    xor_reg <= in_reg1[0] ^ in_reg2[1] ^ in_reg3[2];
end

assign out_and = and_reg;
assign out_or = or_reg;
assign out_xor = xor_reg;

endmodule