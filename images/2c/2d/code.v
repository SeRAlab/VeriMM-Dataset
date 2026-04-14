module wallace_tree_adder (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    output [8:0] sum
);
    wire [15:0] partial0, partial1, partial2;
    
    // Generate partial products
    assign partial0 = a + b;
    assign partial1 = partial0 + c;

    // Assign the final output
    assign sum = partial1;

endmodule