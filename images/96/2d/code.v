module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y,

    input VPB,
    input VPWR,
    input VGND,
    input VNB
);wire w1, w2, w3, w4, w5;

assign w1 = ~(A | B);
assign w2 = ~(C | D);
assign w3 = ~(w1 | w2);
assign w4 = ~(w1 & w2);
assign w5 = ~(w3 & w4);
assign Y = ~(w5);

endmodule