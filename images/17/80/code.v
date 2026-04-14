module aes_8bit(  
    input wire clk,  
    input wire reset,  
    input wire [7:0] plaintext,  
    input wire [7:0] key,  
    output reg [7:0] ciphertext  
);  

    reg [7:0] sbox [0:255];  
    reg [7:0] state;  

    initial begin  
        // Initialize S-Box (simplified for demonstration purposes)  
        sbox[0] = 8'h63;  
        sbox[1] = 8'h7c;  
        //... (initialize other values)  
        sbox[255] = 8'h16;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            ciphertext <= 8'b0;  
            state <= 8'b0;  
        end else begin  
            // AddRoundKey  
            state <= plaintext ^ key;  
            // SubBytes  
            state <= sbox[state];  
            // ShiftRows (for 8 bits it is trivial, just an identity operation)  
            // MixColumns (trivial implementation for 8 bits)  
            ciphertext <= state;  
        end  
    end  
endmodule