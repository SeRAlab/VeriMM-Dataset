module simple_DES(
    input wire clk,
    input wire reset,
    input wire [63:0] plaintext,
    input wire [63:0] key,
    output reg [63:0] ciphertext
);
    // Simplified DES encryption logic (1 round)
    reg [63:0] IP, EP, K, SB, P, FP;
    
    // Initial permutation
    always @(*) begin
        IP = {plaintext[0], plaintext[1], plaintext[2], plaintext[3], plaintext[4], plaintext[5],
              plaintext[6], plaintext[7], plaintext[8], plaintext[9], plaintext[10], plaintext[11],
              plaintext[12], plaintext[13], plaintext[14], plaintext[15], plaintext[16], plaintext[17],
              plaintext[18], plaintext[19], plaintext[20], plaintext[21], plaintext[22], plaintext[23],
              plaintext[24], plaintext[25], plaintext[26], plaintext[27], plaintext[28], plaintext[29],
              plaintext[30], plaintext[31], plaintext[32], plaintext[33], plaintext[34], plaintext[35],
              plaintext[36], plaintext[37], plaintext[38], plaintext[39], plaintext[40], plaintext[41],
              plaintext[42], plaintext[43], plaintext[44], plaintext[45], plaintext[46], plaintext[47],
              plaintext[48], plaintext[49], plaintext[50], plaintext[51], plaintext[52], plaintext[53],
              plaintext[54], plaintext[55], plaintext[56], plaintext[57], plaintext[58], plaintext[59],
              plaintext[60], plaintext[61], plaintext[62], plaintext[63]};
    end

    // Key mixing and substitution (simplified)
    always @(*) begin
        EP = {IP[31:0], IP[63:32]};
        K = EP ^ key;  // Mixing with key (XOR operation)
        // Substitution box operation (simplified)
        SB = K; // In practice, would use a substitution box here
        P = SB; // Permutation (simplified)
        FP = P; // Final permutation (simplified)
    end

    // Sequential logic to output ciphertext
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ciphertext <= 64'b0;
        end else begin
            ciphertext <= FP; // Output the result after one round
        end
    end
endmodule