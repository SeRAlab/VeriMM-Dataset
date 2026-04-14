module des_encryption (  
    input clk,  
    input reset,  
    input [7:0] plaintext,  
    input [7:0] key,  
    output reg [7:0] ciphertext  
);  
    reg [7:0] permuted_text;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            ciphertext <= 8'b0;  
        end else begin  
            // Simple permutation (just an example, not real DES)  
            permuted_text[0] <= plaintext[7];  
            permuted_text[1] <= plaintext[5];  
            permuted_text[2] <= plaintext[6];  
            permuted_text[3] <= plaintext[4];  
            permuted_text[4] <= plaintext[0];  
            permuted_text[5] <= plaintext[1];  
            permuted_text[6] <= plaintext[2];  
            permuted_text[7] <= plaintext[3];  
            // XOR with key  
            ciphertext <= permuted_text ^ key;  
        end  
    end  
endmodule