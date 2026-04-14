module simplified_des (
    input wire [63:0] plaintext,
    input wire [63:0] key,
    input wire clk,
    input wire rst,
    output reg [63:0] ciphertext
);
    reg [63:0] round_key [0:15]; // Subkeys for 16 rounds
    reg [63:0] L, R; // Left and Right halves
    integer i;

    // Key scheduling
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the round key generation
            round_key[0] <= key; // Simplified, use key directly
            for (i = 1; i < 16; i = i + 1) begin
                round_key[i] <= {round_key[i-1][62:0], round_key[i-1][63]}; // Simple left shift
            end
            ciphertext <= 64'b0;
        end else begin
            // Initial split
            L <= plaintext[63:32];
            R <= plaintext[31:0];

            // 16 rounds of encryption
            for (i = 0; i < 16; i = i + 1) begin
                {L, R} <= {R, L ^ (R ^ round_key[i])}; // Simplified Feistel function
            end

            ciphertext <= {R, L}; // Combine halves for ciphertext
        end
    end
endmodule