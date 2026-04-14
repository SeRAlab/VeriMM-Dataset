module top_module(
    input A,
    input B,
    output X
);// Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire A_N;
    wire not0_out;
    wire and0_out_X;

    // Invert input A
    not not0 (not0_out, A);
    assign A_N = ~A;

    // AND gate with special requirement
    and and0 (and0_out_X, not0_out, B);
    assign X = (A == 1'b1) ? and0_out_X : ~and0_out_X;

endmodule