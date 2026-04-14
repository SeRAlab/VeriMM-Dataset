module aes_simple (
    input [3:0] plaintext,
    input [3:0] key,
    input clk,
    input rst,
    output reg [3:0] ciphertext
);

    // S-box for SubBytes step
    reg [3:0] sbox[0:15];
    initial begin
        sbox[0] = 4'h6; sbox[1] = 4'h5; sbox[2] = 4'h4; sbox[3] = 4'h3;
        sbox[4] = 4'h2; sbox[5] = 4'h1; sbox[6] = 4'h0; sbox[7] = 4'h9;
        sbox[8] = 4'h8; sbox[9] = 4'h7; sbox[10] = 4'hE; sbox[11] = 4'hD;
        sbox[12] = 4'hC; sbox[13] = 4'hB; sbox[14] = 4'hA; sbox[15] = 4'hF;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 4'b0000;
        end else begin
            // SubBytes
            ciphertext <= sbox[plaintext] ^ key; // AddRoundKey step included here
        end
    end
endmodule