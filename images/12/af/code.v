module aes_8bit_encrypt (  
    input       [7:0] plaintext,  
    input       [127:0] key,  
    input       [7:0] iv,  
    input       clk,  
    input       rst,  
    output reg  [7:0] ciphertext  
);  
reg [7:0] round_key;  
reg [7:0] state;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        ciphertext <= 8'b0;  
        state <= 8'b0;  
        round_key <= key[7:0];  
    end else begin  
        // Simple XOR operation as a placeholder for AES round  
        state <= plaintext ^ round_key ^ iv;  
        ciphertext <= state;  
    end  
end  
endmodule