module top_module(
    input a,
    input b,
    output sum,
    output carry
);assign sum = a ^ b;   // Sum is the XOR of inputs
    assign carry = a & b; // Carry is the AND of inputs

endmodule