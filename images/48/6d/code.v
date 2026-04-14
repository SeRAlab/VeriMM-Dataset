module top_module(
    input a, b,
    output sum, cout );assign sum = a ^ b;    // Sum is A XOR B
    assign cout = a & b;   // Carry out is A AND B

endmodule