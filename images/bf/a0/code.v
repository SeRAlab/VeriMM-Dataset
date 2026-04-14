module top_module(
    X,
    A1,
    A2,
    A3,
    B1,
    C1
);output X;
    input A1;
    input A2;
    input A3;
    input B1;
    input C1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire a_and;
    wire b_and;
    wire x_or;

    // AND gate for A1, A2, and A3
    assign a_and = A1 & A2 & A3;

    // AND gate for B1 and C1
    assign b_and = B1 & C1;

    // OR gate for a_and and b_and
    assign x_or = a_and | b_and;

    // Output
    assign X = x_or;

endmodule