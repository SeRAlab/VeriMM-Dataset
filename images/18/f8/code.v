module des_encryption (
    input wire clk,
    input wire reset,
    input wire [7:0] plaintext,
    input wire [7:0] key,
    output reg [7:0] ciphertext
);
    reg [7:0] sbox [0:15]; // Simple S-box for substitution
    reg [7:0] perm; // Permutation result

    initial begin
        // Initialize S-box values (example values)
        sbox[0] = 8'h3; sbox[1] = 8'h1; sbox[2] = 8'h4; sbox[3] = 8'h2;
        sbox[4] = 8'h5; sbox[5] = 8'h7; sbox[6] = 8'h0; sbox[7] = 8'h6;
        sbox[8] = 8'hC; sbox[9] = 8'hE; sbox[10] = 8'hB; sbox[11] = 8'hA;
        sbox[12] = 8'hD; sbox[13] = 8'hF; sbox[14] = 8'h9; sbox[15] = 8'h8;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ciphertext <= 8'h00;
        end else begin
            // Simple substitution using S-box
            perm = sbox[plaintext[3:0]] ^ key[3:0]; // XOR with key
            ciphertext <= {perm[3:0], perm[7:4]}; // Swap and output
        end
    end
endmodule