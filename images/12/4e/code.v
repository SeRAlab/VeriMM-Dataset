module aes_8bit (
    input wire [7:0] plaintext,
    input wire [7:0] key,
    input wire enable,
    output reg [7:0] ciphertext,
    input wire clk
);
    // Simplified AES encryption process (not actual AES)
    always @(posedge clk) begin
        if (enable) begin
            ciphertext <= plaintext ^ key; // Simple XOR for demonstration
        end
    end
endmodule