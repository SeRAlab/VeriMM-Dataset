module aes_128_encryption (  
    input wire [127:0] plaintext,  
    input wire [127:0] key,  
    output reg [127:0] ciphertext,  
    input wire clk,  
    input wire rst  
);  

    reg [127:0] state;  
    reg [127:0] round_key;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= 128'b0;  
            round_key <= 128'b0;  
            ciphertext <= 128'b0;  
        end else begin  
            // AddRoundKey  
            round_key <= key;  
            state <= plaintext ^ round_key;  

            // For simplicity, we will only implement a single round.  
            // Normally, this would include SubBytes, ShiftRows, and MixColumns.  
            ciphertext <= state;  
        end  
    end  
endmodule