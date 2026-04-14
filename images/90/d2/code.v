module top_module(
    input a,
    input b,
    input c,
    output x
);wire not_a;
    wire not_b;
    wire not_c;
    wire a_and_b;
    wire b_and_c;
    wire c_and_a;
    wire xor1;
    wire xor2;

    // Invert input bits
    not inv_a (not_a, a);
    not inv_b (not_b, b);
    not inv_c (not_c, c);

    // Compute ANDs
    and and_ab (a_and_b, a, b);
    and and_bc (b_and_c, b, c);
    and and_ca (c_and_a, c, a);

    // Compute XORs
    xor xor1_gate (xor1, not_a, b_and_c);
    xor xor2_gate (xor2, a_and_b, not_c);

    // Compute final XOR
    xor final_xor (x, xor1, xor2);

endmodule