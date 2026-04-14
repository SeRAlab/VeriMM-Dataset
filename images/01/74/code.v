module simple_des_round(  
    input [63:0] plaintext,  
    input [63:0] key,  
    output reg [63:0] ciphertext  
);  
    // Initial permutation example (not actual DES IP)  
    wire [63:0] permuted_input;  
    assign permuted_input = {plaintext[63:56], plaintext[55:48], plaintext[47:40], plaintext[39:32],  
                             plaintext[31:24], plaintext[23:16], plaintext[15:8], plaintext[7:0]};  
                             
    // Simple DES function: XOR with key  
    always @(*) begin  
        ciphertext = permuted_input ^ key;  
    end  
endmodule