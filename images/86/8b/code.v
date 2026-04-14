module top_module(
    input  A1,
    input  A2,
    input  A3,
    input  A4,
    input  B1,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // AND gate implementation
    wire and_out;
    assign and_out = A1 & A2;

    // OR gate implementation
    wire or_out;
    assign or_out = A3 | A4;

    // Output selection based on B1
    assign X = B1 ? and_out : or_out;

endmodule