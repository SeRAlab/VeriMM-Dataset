module top_module(
    input wire clk_in,
    input wire in,
    output wire out
);reg ff;
always @(posedge clk_in)
    ff <= in;

assign out = !ff && in;

endmodule