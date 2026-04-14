module top_module(
    input a,
    input b,
    input c,
    output sum,
    output carry
);assign sum = a ^ b ^ c;      // Sum is the XOR of a, b, and c
    assign carry = (a & b) | (b & c) | (a & c); // Carry is the majority function
endmodule