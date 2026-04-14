module des_encryption (
    input wire clk,
    input wire [2:0] plaintext,
    input wire [2:0] key,
    output reg [2:0] ciphertext
);
    always @(posedge clk) begin
        ciphertext <= (plaintext << 1) ^ key; // Shift left by 1 and XOR with key
    end
endmodule