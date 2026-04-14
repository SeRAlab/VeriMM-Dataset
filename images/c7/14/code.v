module nor3 (
    input A,
    input B,
    input C,
    output Y,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);

wire temp1, temp2;

not (temp1, A);
not (temp2, B);
or (Y, temp1, temp2);
not (temp1, C);
or (Y, Y, temp1);

endmodule