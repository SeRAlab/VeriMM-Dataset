module carry_save_adder(
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    output [4:0] sum
);
    wire [4:0] sum_ab, sum_abc;

    // Perform initial addition of a and b
    assign sum_ab = a + b;

    // Perform addition of the intermediate result with c
    assign sum_abc = sum_ab + c;

    // Output the final sum
    assign sum = sum_abc;

endmodule