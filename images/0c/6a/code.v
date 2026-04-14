module DES (  
    input [63:0] plaintext,  
    input [63:0] key,  
    output reg [63:0] ciphertext  
);  
    // Internal wires and registers  
    wire [63:0] IP, FP, L, R, F_out;  
    wire [31:0] round_key;  

    // Initial permutation (IP)  
    assign IP = {plaintext[39:32], plaintext[7:0], plaintext[15:8], plaintext[23:16],  
                  plaintext[31:24], plaintext[63:56], plaintext[55:48], plaintext[47:40],  
                  plaintext[63:56], plaintext[55:48], plaintext[47:40], plaintext[31:24],  
                  plaintext[23:16], plaintext[15:8], plaintext[7:0], plaintext[63:56]};  

    // Split into L and R  
    assign L = IP[63:32];  
    assign R = IP[31:0];  

    // Round key generation (simple example, should use key schedule)  
    assign round_key = key[63:32];  

    // Function F (simplified example)  
    assign F_out = R ^ round_key; // XOR with round key for simplification  

    always @(*) begin  
        // DES round (simplified)  
        ciphertext = {R, L ^ F_out};  
        // Final permutation (FP)  
        ciphertext = {ciphertext[39:32], ciphertext[7:0], ciphertext[15:8], ciphertext[23:16],  
                      ciphertext[31:24], ciphertext[63:56], ciphertext[55:48], ciphertext[47:40],  
                      ciphertext[63:56], ciphertext[55:48], ciphertext[47:40], ciphertext[31:24],  
                      ciphertext[23:16], ciphertext[15:8], ciphertext[7:0], ciphertext[63:56]};  
    end  
endmodule