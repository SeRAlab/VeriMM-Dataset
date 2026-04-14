module carry_save_adder (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [4:0] sum
);
    wire [4:0] carry_ab, carry_ac, carry_bc;

    // Adding A and B
    assign carry_ab = A + B;

    // Adding carry_ab and C
    assign carry_ac = carry_ab + C;

    assign sum = carry_ac;
endmodule