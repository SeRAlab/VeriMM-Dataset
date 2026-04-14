module csa_4bit (
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    output [3:0] sum,
    output [3:0] carry
);
    wire [4:0] temp_sum;
    
    // First stage: Add A and B
    assign temp_sum = A + B;
    
    // Second stage: Add the carry from the first stage to C
    assign sum = temp_sum[3:0] ^ C; // sum is obtained by XORing with C
    assign carry = {1'b0, temp_sum[4]} | ((temp_sum[3:0] & C)); // carry is obtained from the carry out and the carry from the AND operation
endmodule