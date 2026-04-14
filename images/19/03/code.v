module des_single_round (  
    input wire [63:0] plaintext,  
    input wire [63:0] key,  
    output reg [63:0] ciphertext  
);  
    // Simple substitution and permutation for demonstration  
    always @(plaintext or key) begin  
        // For the sake of simplicity, let's just XOR the plaintext with the key  
        ciphertext = plaintext ^ key;  
    end  
endmodule