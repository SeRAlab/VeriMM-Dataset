module aes_encrypt (
    input wire clk,
    input wire rst,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    // Simple substitution and permutation (not actual AES)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 8'b0;
        end else begin
            // Substitute each nibble (4 bits) using a simple operation
            ciphertext[7:4] <= plaintext[7:4] ^ key[7:4]; // XOR the upper nibble
            ciphertext[3:0] <= plaintext[3:0] ^ key[3:0]; // XOR the lower nibble
        end
    end
endmodule