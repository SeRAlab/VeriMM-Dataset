module top_module(input A, B, C, VPWR, VGND, VPB, VNB, output Y);assign Y = ~(A | B | C);
endmodule