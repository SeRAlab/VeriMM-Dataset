module aes_encrypt (  
    input wire clk,  
    input wire rst,  
    input wire [127:0] plaintext,  
    input wire [127:0] key,  
    output reg [127:0] ciphertext  
);  

    reg [127:0] state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 128'b0;  
            ciphertext <= 128'b0;  
        end else begin  
            // AddRoundKey operation (XOR with key)  
            state <= plaintext ^ key;  
            // For simplicity, we will not implement the full AES round here.  
            // In a complete implementation, you would add SBox substitution, shift rows, mix columns, etc.  
            ciphertext <= state; // Just passing state for demonstration  
        end  
    end  
endmodule