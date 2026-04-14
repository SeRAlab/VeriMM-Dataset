module carry_save_adder (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    output [3:0] sum,
    output [3:0] carry
);
    wire [4:0] temp_sum;
    wire [4:0] temp_carry;

    assign temp_sum = a ^ b ^ c; // Sum bits (XOR)
    assign temp_carry = (a & b) | (b & c) | (c & a); // Carry bits (AND-OR)

    assign sum = temp_sum[3:0]; // 4-bit sum
    assign carry = temp_carry[3:0]; // 4-bit carry (maximum of 4 bits necessary)

endmodule