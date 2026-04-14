module top_module(
    input D,
    input RESET_B,
    input GATE,
    input CLK,
    output Q,
    output Q_N
);wire AND1_out;
    wire AND2_out;
    wire OR1_out;
    wire NOT1_out;
    wire NOT2_out;

    // AND1 gate for GATE and CLK
    assign AND1_out = GATE & CLK;

    // AND2 gate for NOT GATE and CLK
    assign AND2_out = ~GATE & CLK;

    // OR1 gate for AND1_out and NOT RESET_B
    assign OR1_out = AND1_out | ~RESET_B;

    // NOT1 gate for OR1_out
    assign NOT1_out = ~OR1_out;

    // NOT2 gate for AND2_out
    assign NOT2_out = ~AND2_out;

    // D-latch with reset behavior implemented in basic gates (instead of missing sky130 module)
    assign Q = (D & NOT1_out) | (Q & NOT2_out); // Output logic
    assign Q_N = ~Q; // Inverted output

endmodule