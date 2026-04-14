module aes_8bit (
    input wire [7:0] plaintext,
    input wire [7:0] key,
    input wire clk,
    output reg [7:0] ciphertext
);
    // Simple AES encryption logic (placeholder for actual AES implementation)
    always @(posedge clk) begin
        ciphertext <= plaintext ^ key; // XOR operation as a placeholder
    end
endmodule