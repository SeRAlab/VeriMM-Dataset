module wallace_tree_adder (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    output [4:0] sum
);
    wire [4:0] ab_sum;
    wire [4:0] abc_sum;

    // First stage: add a and b
    assign ab_sum = a + b;

    // Second stage: add the result with c
    assign abc_sum = ab_sum + c;

    // Output the final sum
    assign sum = abc_sum;

endmodule