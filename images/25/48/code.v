module aes_8bit (  
    input wire [7:0] plaintext,  
    input wire [7:0] key,  
    input wire clk,  
    input wire rst,  
    output reg [7:0] ciphertext  
);  
    // Simple round operation for demonstration  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ciphertext <= 8'b00000000;  
        end else begin  
            ciphertext <= plaintext ^ key; // Example operation: XOR  
        end  
    end  
endmodule