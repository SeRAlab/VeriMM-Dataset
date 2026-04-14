module aes_encrypt (
    input wire [7:0] plaintext,
    input wire [7:0] key,
    input wire clk,
    input wire rst,
    output reg [7:0] ciphertext
);
    reg [7:0] sbox [0:255];
    reg [7:0] state;

    initial begin
        // Initialize S-box with some values (this should be the actual AES S-box)
        // For simplicity, this example uses a smaller S-box; in practice, use the full AES S-box.
        sbox[8'h00] = 8'h63; sbox[8'h01] = 8'h7c; // ... and so on for all 256 entries
        sbox[8'hff] = 8'h00; // Last entry
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 8'b0;
            state <= 8'b0;
        end else begin
            state <= sbox[plaintext]; // Substitute step
            ciphertext <= state ^ key; // AddRoundKey step
        end
    end
endmodule