module aes_8bit (  
    input wire clk,  
    input wire [7:0] plain_text,  
    input wire [7:0] key,  
    output reg [7:0] cipher_text  
);  
    // Simple AES round implementation (not full AES)  
    reg [7:0] sbox [0:255];  
    initial begin  
        // Initialize S-box (example values)  
        sbox[0] = 8'h63; sbox[1] = 8'h7c; sbox[2] = 8'h77; // ...  
        // More S-box values should be initialized here  
    end  

    always @(posedge clk) begin  
        // Perform a simple encryption round  
        cipher_text <= sbox[plain_text ^ key];  
    end  
endmodule