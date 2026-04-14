module three_to_one (
    input A1,
    input A2,
    input B1_N,
    output Y,
    input VPWR,
    input VGND
);

    assign Y = (A1 && A2) ? 1'b1 :
               (A1 && !A2) ? 1'b0 :
               (!A1 && A2) ? 1'b0 :
               (!A1 && !A2 && !B1_N) ? 1'b1 :
               (!A1 && !A2 && B1_N) ? 1'b0 :
               1'b0;

endmodule