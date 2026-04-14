module top_module(
    output X,
    input A1,
    input A2,
    input B1,
    input C1
);assign X = (A1 && !A2) ? B1 :
               (!A1 && A2) ? C1 :
               (A1 && A2) ? 1 :
               0;

endmodule