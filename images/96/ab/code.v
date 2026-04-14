module top_module(
    input A_N,
    input B,
    input C,
    input D,
    output Y,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);wire temp1, temp2, temp3;

not (temp1, A_N);
and (temp2, temp1, B);
and (temp3, temp2, C);
and (Y, temp3, D);

endmodule