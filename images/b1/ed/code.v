module full_adder_1bit(
    input a,            // 1-bit binary input.
    input b,            // 1-bit binary input.
    input cin,          // 1-bit carry input.

    output sum,         // 1-bit sum output.
    output cout         // 1-bit carry output.
);

assign sum = a ^ b ^ cin; // Sum is XOR of a, b, and cin.
assign cout = (a & b) | (b & cin) | (a & cin); // Carry-out is the majority function.

endmodule