module aes_128_encryption(  
    input clk,  
    input rst,  
    input enable,  
    input [127:0] plaintext,  
    input [127:0] key,  
    output reg [127:0] ciphertext  
);  
    reg [127:0] state;  
    reg [127:0] round_key;  

    // Key expansion (for simplicity, assume round_key is generated somehow)  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            round_key <= 128'h0;  
        end else if (enable) begin  
            round_key <= key; // Assume key expansion is trivial for this example  
            state <= plaintext;  
            // Round 1 transformations (simplified)  
            state <= state ^ round_key; // AddRoundKey  
            // SubBytes, ShiftRows, MixColumns would go here  
            // For simplicity, just a single round is performed  
            ciphertext <= state;  
        end  
    end  
endmodule