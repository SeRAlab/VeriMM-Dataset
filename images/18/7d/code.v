module carry_save_adder (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [3:0] sum,
    output [3:0] carry
);
    wire [4:0] temp_sum;
    wire [4:0] temp_carry;

    assign temp_sum = A + B + C;  // Sum of all three inputs
    assign carry = temp_sum[4:1];  // Carry out from the highest bit
    assign sum = temp_sum[3:0];     // Sum output

endmodule