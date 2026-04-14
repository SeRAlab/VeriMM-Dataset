module aes_8bit (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] plaintext,  
    input wire [127:0] key,  
    output reg [7:0] ciphertext  
);  
    // Simple AES-like transformation for the sake of this example  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ciphertext <= 8'b0;  
        end else begin  
            // This is a placeholder for the AES transformation  
            ciphertext <= plaintext ^ key[7:0]; // Simple XOR for demonstration  
        end  
    end  
endmodule