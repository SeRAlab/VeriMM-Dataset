module top_module(
    A,
    B,
    S,
    OUT,
    SLEEP_B
);// Module ports
    input A;
    input B;
    input S;
    output OUT;
    input SLEEP_B;

    // Local signals
    wire SLEEP;

    //  Name  Output  Other arguments
    not not0 (SLEEP , SLEEP_B        );

    // 2-to-1 mux
    assign OUT = (S) ? B : A;

    // Sleep mode
    assign OUT = (SLEEP) ? 1'b0 : OUT;

endmodule