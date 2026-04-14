module decoder_3to8 (
    input wire A,
    input wire B,
    input wire C,
    output wire Y0,
    output wire Y1,
    output wire Y2,
    output wire Y3,
    output wire Y4,
    output wire Y5,
    output wire Y6,
    output wire Y7
    );

assign Y0 = ~A & ~B & ~C;
assign Y1 = ~A & ~B &  C;
assign Y2 = ~A &  B & ~C;
assign Y3 = ~A &  B &  C;
assign Y4 =  A & ~B & ~C;
assign Y5 =  A & ~B &  C;
assign Y6 =  A &  B & ~C;
assign Y7 =  A &  B &  C;

endmodule