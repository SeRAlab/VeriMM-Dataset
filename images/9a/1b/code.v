module top_module(
    X    ,
    A    ,
    SLEEP
);// Module ports
    output X    ;
    input  A    ;
    input  SLEEP;

    // Local signals
    wire sleepn;

    //  Name  Output  Other arguments
    not not0 (sleepn, SLEEP          );
    and and0 (X     , A, sleepn      );

endmodule