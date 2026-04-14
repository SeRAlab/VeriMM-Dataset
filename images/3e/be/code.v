module monte_carlo_adder(
    input [4:0] A, 
    input [4:0] B, 
    input [4:0] C, 
    output [4:0] Y
);
    wire [5:0] sum; // To handle potential overflow
    assign sum = A + B; // Sum of A and B
    assign Y = sum[4:0] ^ C; // XOR with C, retaining only the least significant 5 bits
endmodule