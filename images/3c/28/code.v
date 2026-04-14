module aes_8bit(
    input wire clk,
    input wire rst,
    input wire [7:0] plaintext,
    output reg [7:0] ciphertext
);
    reg [7:0] key = 8'h2b; // Example fixed key
    reg [7:0] sbox [0:15]; // S-box for substitution
    reg [7:0] state;

    // Initialize S-box
    initial begin
        sbox[0] = 8'h63; sbox[1] = 8'h7c; sbox[2] = 8'h77; sbox[3] = 8'h7b;
        sbox[4] = 8'hf2; sbox[5] = 8'h6b; sbox[6] = 8'h6f; sbox[7] = 8'hc5;
        sbox[8] = 8'h30; sbox[9] = 8'h01; sbox[10] = 8'h67; sbox[11] = 8'h2b;
        sbox[12] = 8'hfe; sbox[13] = 8'hd7; sbox[14] = 8'hab; sbox[15] = 8'h76;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 8'b0;
        end else begin
            // Simple AES-like operation: Substitute and mix with key
            state <= sbox[plaintext[3:0]] ^ key; // Substitute using S-box and XOR with key
            ciphertext <= {state[7:4], state[3:0]} ^ key; // Permutation and XOR with key again
        end
    end
endmodule