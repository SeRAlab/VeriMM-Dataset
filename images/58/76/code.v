module top_module(
    X,
    A,
    SLEEP_B,
    VPWR,
    KAGND,
    VPB,
    VNB
);output X;
    input A, SLEEP_B, VPWR, KAGND, VPB, VNB;

    wire should_power_on = A & ~SLEEP_B;

    assign X = should_power_on & VPWR & KAGND & VPB & VNB;

endmodule