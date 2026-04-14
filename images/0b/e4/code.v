module DES_round (  
    input [63:0] plaintext,  
    input [55:0] key,  
    output reg [63:0] ciphertext  
);  

    // Internal signals  
    reg [31:0] left, right;  
    reg [31:0] new_left, new_right;  
    reg [55:0] subkey;  

    // Key schedule (for this simplified version, we just use the key directly)  
    always @(*) begin  
        subkey = key;  
    end  

    // Initial permutation (simplified version)  
    always @(*) begin  
        left = plaintext[63:32];  
        right = plaintext[31:0];  
    end  

    // DES round function (simplified)  
    always @(*) begin  
        new_left = right;  
        new_right = left ^ (right ^ subkey[31:0]); // Example function: XOR with subkey  

        // Update ciphertext  
        ciphertext = {new_left, new_right};  
    end  
endmodule