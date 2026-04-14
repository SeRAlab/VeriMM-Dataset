module phase_detector (
    input wire A,
    input wire B,
    output wire lead,
    output wire lag,
    output wire in_phase
);
    assign lead = (A & ~B);         // A leads B when A is high and B is low
    assign lag = (~A & B);          // A lags B when A is low and B is high
    assign in_phase = (A == B);     // Both signals are in phase when they are equal
endmodule