module top_module(
    X,
    A,
    SLEEP_B,
    VPWR,
    VGND
);// Module ports
    output X;
    input A;
    input SLEEP_B;
    input VPWR;
    input VGND;

    // Local signals
    wire SLEEP;
    wire or0_out_X;
    wire and0_out_X;

    //                                   Name         Output     Other arguments
    not                                  not0        (SLEEP    , SLEEP_B              );
    or                                   or0         (or0_out_X, A, SLEEP             );
    and                                  and0        (and0_out_X, VPWR, ~VGND         );
    assign X = or0_out_X & and0_out_X;

endmodule