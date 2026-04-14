module rsa_encrypt (
    input [15:0] P,  // Plaintext input
    input [15:0] N,  // Modulus
    output [15:0] C  // Ciphertext output
);
    wire [31:0] P_cubed;
    wire [15:0] remainder;

    assign P_cubed = P * P * P; // P^3
    assign remainder = P_cubed % N; // C = P^3 mod N

    assign C = remainder;

endmodule