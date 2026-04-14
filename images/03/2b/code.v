module carry_save_adder (
    input [2:0] A,
    input [2:0] B,
    input [2:0] C,
    output [3:0] S,
    output [2:0] C_out
);
    wire [3:0] sum_ab, sum_abc;
    wire [2:0] carry_ab, carry_ac, carry_bc;

    // Step 1: Add A and B
    assign sum_ab = A + B;
    
    // Step 2: Add the result with C
    assign {C_out, S} = sum_ab + C;

endmodule