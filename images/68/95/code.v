module top_module(
    input a, b,
    output sum, carry
);assign sum = a ^ b;    // Sum is XOR of inputs
assign carry = a & b;  // Carry is AND of inputs
endmodule