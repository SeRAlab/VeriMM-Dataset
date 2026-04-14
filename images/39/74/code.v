module aes_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    // Simplified AES operation for 8-bit
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ciphertext <= 8'b0;
        end else begin
            // A simple encryption operation (XOR with key for demonstration)
            ciphertext <= plaintext ^ key;
        end
    end
endmodule