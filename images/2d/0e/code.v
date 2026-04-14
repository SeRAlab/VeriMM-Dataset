module aes_encryption (  
    input clk,  
    input reset,  
    input [127:0] plaintext,  
    input [127:0] key,  
    output reg [127:0] ciphertext  
);  

    reg [127:0] round_key;  
    reg [127:0] state;  

    // Simple key expansion (for one round)  
    always @(*) begin  
        round_key = key ^ 32'h1; // Simplistic example: just xor with a constant  
    end  

    // AES encryption process (one round)  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= 128'b0;  
            ciphertext <= 128'b0;  
        end else begin  
            state <= plaintext ^ round_key; // Simple XOR for this example  
            ciphertext <= state;  
        end  
    end  
endmodule