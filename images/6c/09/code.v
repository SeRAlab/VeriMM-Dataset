module top_module(
    X,
    A,
    SLEEP,
    VPWR
);// Module ports
    output X;
    input A, SLEEP, VPWR;

    // Module supplies
    supply1 VPB;
    supply1 DESTVPB;
    supply1 DESTPWR;
    supply0 VGND;
    supply0 VNB;

    // Local signals
    wire sleepb;

    // Invert SLEEP to get sleepb
    not not_sleep (sleepb, SLEEP);

    // Use a mux to select between A and 0 based on SLEEP
    assign X = sleepb ? 0 : A;

endmodule