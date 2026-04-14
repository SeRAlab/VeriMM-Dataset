module top_module(
    a,
    b,
    c,
    d,
    out
);input a, b, c, d;
    output out;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    wire w1, w2, w3;

    // Assuming the missing xor2 module is defined as a simple 2-input XOR gate
    assign w1 = a ^ b;
    assign w2 = c ^ d;
    assign w3 = w1 ^ w2;
    assign out = w3 ^ 1'b0; // This line can be simplified, but kept for structure

endmodule