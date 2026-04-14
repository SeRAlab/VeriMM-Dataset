module top_module(
    input a,
    input b,
    input cin,
    output s,
    output cout
);assign s = a ^ b ^ cin;  // Sum bit
    assign cout = (a & b) | (cin & (a ^ b)); // Carry out
endmodule