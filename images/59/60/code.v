module top_module(
    input a, b,
    output cout, sum
);reg s1, s2, c1;

assign sum = s2;
assign cout = c1;

// Stage 1
assign s1 = a ^ b;
assign c1 = a & b;

// Stage 2
assign s2 = s1 ^ c1;

endmodule