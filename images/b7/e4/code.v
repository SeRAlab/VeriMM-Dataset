module top_module(
    input A,
    input B,
    input C,
    input D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Y
);// Replace with standard Verilog gates if the libraries are not available
wire nand_AB;
wire nand_CD;
wire nand_ABCD;

// Using builtin NAND gates instead of undefined sky130_fd_sc_ls__nand2
assign nand_AB = ~(A & B);
assign nand_CD = ~(C & D);
assign nand_ABCD = ~(nand_AB & nand_CD);
assign Y = ~nand_ABCD; // This is equivalent to a NAND followed by a NOT

endmodule