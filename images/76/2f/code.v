module top_module(
    input A,
    input B,
    input C,
    output X
);// Module supplies
    supply1 VPWR;
    supply0 VGND;

    // Local signals
    wire or_out;

    // OR gate implementation
    assign or_out = A | B | C;

    // Buffer implementation
    assign X = or_out;

endmodule