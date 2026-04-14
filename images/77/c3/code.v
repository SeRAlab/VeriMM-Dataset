module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output reg Y
);wire [3:0] AB, CD, ABCD;
    assign AB = A ^ B;
    assign CD = C ^ D;
    assign ABCD = AB ^ CD;
    assign Y = ~(ABCD[0] | ABCD[1] | ABCD[2] | ABCD[3]);

endmodule