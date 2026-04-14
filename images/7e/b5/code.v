module top_module(
    X   ,
    A   ,
    B   ,
    C   ,
    VPWR,
    VGND
);output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  VPWR;
    input  VGND;

    wire AB;
    wire ABC;

    // Replacing sky130_fd_sc_hs__and2b_1 with an AND gate implemented with basic gates
    wire A_N;

    // Inverting A to get A_N
    not (A_N, A);

    // AND gate to generate AB
    wire AND_AB;
    and (AND_AB, A_N, B);
    
    // AND gate to generate ABC
    and (ABC, AND_AB, C);

    // Assign the final output
    assign X = ABC;

endmodule