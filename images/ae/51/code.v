module top_module(
    input clk,
    input [7:0] d,
    output [7:0] q
);reg [7:0] q_reg1, q_reg2, q_reg3, q_reg4, q_reg5, q_reg6, q_reg7, q_reg8;

always @(negedge clk) begin
    q_reg1 <= d;
    q_reg2 <= q_reg1;
    q_reg3 <= q_reg2;
    q_reg4 <= q_reg3;
    q_reg5 <= q_reg4;
    q_reg6 <= q_reg5;
    q_reg7 <= q_reg6;
    q_reg8 <= q_reg7;
end

assign q = q_reg8;

endmodule