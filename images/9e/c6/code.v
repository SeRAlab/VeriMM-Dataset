module top_module(
    input a,
    input b,
    input sel,
    output out
);wire sel_nand;
wire a_nand;
wire b_nand;

assign sel_nand = ~(sel & sel);
assign a_nand = ~(a & sel);
assign b_nand = ~(b & ~sel);

assign out = ~(sel_nand & a_nand) & ~(sel_nand & b_nand);

endmodule