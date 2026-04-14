module aes_encrypt (
    input wire clk,
    input wire rst,
    input wire [7:0] plaintext,
    input wire [3:0] key,
    output reg [7:0] ciphertext
);
    reg [7:0] state;
    reg [7:0] roundKey;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 8'b0;
            roundKey <= 8'b0;
            ciphertext <= 8'b0;
        end else begin
            // AddRoundKey
            roundKey = {key, 4'b0} ^ state;
            // SubBytes dummy implementation (identity for simplicity)
            state = roundKey;
            // ShiftRows dummy implementation (identity for simplicity)
            ciphertext <= state; // Output the final ciphertext
        end
    end
endmodule