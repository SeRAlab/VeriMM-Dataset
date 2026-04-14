module simple_DES(  
    input wire [63:0] plaintext,  
    input wire [63:0] key,  
    output reg [63:0] ciphertext  
);  
    // Internal wire declarations  
    wire [31:0] left, right, expanded_right;  
    wire [47:0] subkey;  
    wire [31:0] xor_result, sbox_output;  
    wire [63:0] permuted_output;  
    
    // Initial assignments  
    assign left = plaintext[63:32];  
    assign right = plaintext[31:0];  
    assign subkey = key[63:16]; // For simplicity, using first 48 bits of key as subkey  
    assign expanded_right = {right[31:0], right[31:0]}; // Simple expansion for demonstration  
    assign xor_result = expanded_right ^ subkey;  
    
    // S-box simulation  
    assign sbox_output = xor_result[31:0]; // Simple pass-through for demonstration  
    assign permuted_output = {sbox_output, left}; // Swap and permute for one round  
    
    always @(*) begin  
        ciphertext = permuted_output;  
    end  
endmodule