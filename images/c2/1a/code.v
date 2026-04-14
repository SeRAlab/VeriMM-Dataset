module four_to_one_circuit (
    output X   ,
    input  A1  ,
    input  A2  ,
    input  B1  ,
    input  B2  ,
    input  VPWR,
    input  VGND,
    input  VPB ,
    input  VNB
);

    wire not_A1, not_A2, not_B1, not_B2;

    assign not_A1 = ~A1;
    assign not_A2 = ~A2;
    assign not_B1 = ~B1;
    assign not_B2 = ~B2;

    wire and1, and2, or1;

    assign and1 = not_A1 & not_A2 & not_B1 & B2;
    assign and2 = A1 & A2 & not_B1 & not_B2;
    assign or1 = and1 | and2;

    assign X = ~or1;

endmodule