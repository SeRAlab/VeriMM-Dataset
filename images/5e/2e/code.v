module full_adder(
    input a,            // First 1-bit input signal.
    input b,            // Second 1-bit input signal.
    input cin,          // Carry-in 1-bit input signal.

    output sum,         // Sum output signal.
    output cout         // Carry-out output signal.
);

// Full adder logic
assign sum = a ^ b ^ cin;
assign cout = (a & b) | (b & cin) | (a & cin);

endmodule