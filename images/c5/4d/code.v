module xor_gate(
    input a,
    input b,
    output out_comb
);

    assign out_comb = (a & ~b) | (~a & b);

endmodule