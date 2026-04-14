module xnor_logic (
    input x,
    input y,
    output z);assign z = ~(x ^ y);

endmodule