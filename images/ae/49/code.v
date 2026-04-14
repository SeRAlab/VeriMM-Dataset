module top_module(
    input  A,
    input  B,
    input  C,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire AB = A ^ B;
    wire BC = B ^ C;
    wire AC = A ^ C;

    assign X = (AB ^ C) & (~AB | ~C) & (BC ^ A) & (~BC | ~A) & (AC ^ B) & (~AC | ~B);

endmodule