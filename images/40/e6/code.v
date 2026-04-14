module rsa_encrypt (
    input [7:0] a, // First 8-bit input
    input [7:0] b, // Second 8-bit input
    output reg [7:0] encrypted_out // 8-bit encrypted output
);

parameter e = 3; // Public exponent
parameter n = 55; // Modulus

always @(*) begin
    // Perform RSA encryption: encrypted = (input ^ e) mod n
    encrypted_out = (a * b) % n; // Using multiplication to simulate encryption
end

endmodule