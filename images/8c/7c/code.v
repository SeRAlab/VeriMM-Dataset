module top_module(
    X,
    A1,
    A2,
    B1,
    C1
);output X;
    input A1;
    input A2;
    input B1;
    input C1;

    assign X = (A1) ? 1'b1 :
               (A2) ? 1'b0 :
               (B1) ? 1'b1 :
               (C1) ? 1'b0 :
                      1'b1 ;

endmodule