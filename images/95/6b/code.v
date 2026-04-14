module top_module(
    Y   ,
    A   ,
    B   ,
    C   ,
    D
);output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;

    wire temp1, temp2;

    // Assuming a standard NOR gate is needed, replacing sky130_fd_sc_lp__nor3b with a basic NOR gate structure.
    nor nor_inst1 (
        temp1,
        A,
        B
    );

    nor nor_inst2 (
        temp2,
        C,
        D
    );

    nor nor_inst3 (
        Y,
        temp1,
        temp2
    );

endmodule