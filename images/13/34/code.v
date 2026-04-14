module des_encrypt (  
    input [7:0] plaintext,  
    input [7:0] key,  
    output reg [7:0] ciphertext,  
    input clk,  
    input rst  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            ciphertext <= 8'b0;  
        end else begin  
            // Simple permutation and substitution for demonstration  
            ciphertext <= {plaintext[6:0], plaintext[7]} ^ key;  
        end  
    end  
endmodule