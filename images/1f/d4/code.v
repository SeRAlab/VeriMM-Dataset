module aes_encryptor (
    input wire [127:0] plaintext,
    input wire [127:0] key,
    input wire clk,
    input wire rst,
    output reg [127:0] ciphertext
);
    // Simplified round function for AES
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 128'b0;
        end else begin
            // For simplification, let's just XOR plaintext with key
            ciphertext <= plaintext ^ key; // This is not actual AES logic, just for example
        end
    end
endmodule