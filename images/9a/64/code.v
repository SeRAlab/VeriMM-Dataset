module top_module(
    output wire i0,i1,i2,i3,i4,i5,i6,i7,
    input wire A,B,C
);assign i0 = ~A & ~B & ~C;
    assign i1 = ~A & ~B & C;
    assign i2 = ~A & B & ~C;
    assign i3 = ~A & B & C;
    assign i4 = A & ~B & ~C;
    assign i5 = A & ~B & C;
    assign i6 = A & B & ~C; 
    assign i7 = A & B & C; 

endmodule