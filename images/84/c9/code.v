module top_module(
    input A, B, C, D,
    output Y
);wire AB, AC, AD, BC, BD, CD;

assign AB = A & B;
assign AC = A & C;
assign AD = A & D;
assign BC = B & C;
assign BD = B & D;
assign CD = C & D;

assign Y = (AB | AC | AD | BC | BD | CD);

endmodule