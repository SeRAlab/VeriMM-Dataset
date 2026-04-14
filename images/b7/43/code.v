module top_module(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);assign sum = a ^ b ^ cin;       // Sum calculation
    assign cout = (a & b) | (cin & (a ^ b)); // Carry out calculation
endmodule