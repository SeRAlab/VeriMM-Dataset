module aes_encrypt (  
    input wire [7:0] plaintext,  
    input wire [7:0] key,  
    input wire clk,  
    input wire rst,  
    output reg [7:0] ciphertext  
);  

    // Simple AES round function for demonstration
    reg [7:0] state;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ciphertext <= 8'b0;  
            state <= 8'b0;  
        end else begin  
            // A simple transformation for demonstration purposes
            state <= plaintext ^ key; // XOR plaintext with key  
            ciphertext <= state;  
        end  
    end  
endmodule