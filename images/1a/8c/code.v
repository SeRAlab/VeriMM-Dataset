module aes_encrypt (  
    input [7:0] plaintext,  
    input [7:0] key,  
    input clk,  
    input rst,  
    output reg [7:0] ciphertext  
);  
    reg [7:0] state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 8'b0;  
            ciphertext <= 8'b0;  
        end else begin  
            // Simple AES round operation (XOR with key for demonstration)  
            state <= plaintext ^ key;  
            // Assume a very simple substitution step  
            ciphertext <= state;  
        end  
    end  
endmodule