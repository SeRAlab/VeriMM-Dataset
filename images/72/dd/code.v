module top_module(
    input a,
    input b,
    input c,
    output sum,
    output carry
);assign sum = a ^ b ^ c; // Sum bits using XOR
    assign carry = (a & b) | (b & c) | (a & c); // Carry out
endmodule