module top_module(
    input A,
    input B,
    input C,
    input D,
    output X
);wire AB, AC, AD, BC, BD, CD;
wire ABC, ABD, ACD, BCD;
wire AB_CD, AC_BD, AD_BC;

assign AB = A & B;
assign AC = A & C;
assign AD = A & D;
assign BC = B & C;
assign BD = B & D;
assign CD = C & D;

assign ABC = AB & C;
assign ABD = AB & D;
assign ACD = AC & D;
assign BCD = BC & D;

assign AB_CD = ABC | ABD | CD;
assign AC_BD = ABC | ACD | BD;
assign AD_BC = ABD | ACD | BC;

assign X = AB_CD & AC_BD & AD_BC;

endmodule