module aes_8bit (
    input [7:0] plaintext,
    input [7:0] key,
    output reg [7:0] ciphertext,
    input clk,
    input rst
);
  
    reg [7:0] sbox [0:255];
    reg [7:0] permuted;
    reg [7:0] temp;

    initial begin
        // S-Box initialization (example values)
        sbox[0] = 8'h63; sbox[1] = 8'h7c; sbox[2] = 8'h77; sbox[3] = 8'h7b;
        // ... initialize all values for sbox ...
        sbox[254] = 8'h9c; sbox[255] = 8'h9d;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ciphertext <= 8'b0;
        end else begin
            // Substitution
            temp <= sbox[plaintext];
            // Simple permutation (just an example)
            permuted <= {temp[3:0], temp[7:4]};
            // Key addition
            ciphertext <= permuted ^ key;
        end
    end
endmodule