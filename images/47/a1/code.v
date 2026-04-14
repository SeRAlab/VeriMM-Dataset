module top_module(
    input a,
    input b,
    input ci,
    output sum,
    output co
);assign sum = a ^ b ^ ci; // Full adder sum calculation
    assign co = (a & b) | (ci & (a ^ b)); // Full adder carry out calculation
endmodule