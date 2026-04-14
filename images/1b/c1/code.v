module chacha20_core (  
    input wire [31:0] key,  
    input wire [31:0] nonce,  
    input wire [31:0] counter,  
    input wire [31:0] plaintext,  
    output reg [31:0] ciphertext  
);  

    // Dummy implementation for simplicity.  
    always @(key, nonce, counter, plaintext) begin  
        // Simple logic to generate ciphertext based on inputs  
        ciphertext = plaintext ^ (key + nonce + counter);  
    end  
endmodule