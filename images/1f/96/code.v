module aes_8bit (  
    input wire clk,  
    input wire rst,  
    input wire [7:0] plaintext,  
    input wire [7:0] key,  
    output reg [7:0] ciphertext  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ciphertext <= 8'b0;  
        end else begin  
            // Simple round function (for demonstration purposes)  
            ciphertext <= (plaintext ^ key) + 8'h01; // XOR then increment  
        end  
    end  
endmodule