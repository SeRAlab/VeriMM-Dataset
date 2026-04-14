module aes_round(input [127:0] plaintext, input [127:0] key, output reg [127:0] ciphertext);  
  // Simple ShiftRows and AddRoundKey for one round of AES  
  reg [127:0] shifted_rows;  
  integer i;  

  always @(*) begin  
    // ShiftRows operation (simplified)  
    shifted_rows = {plaintext[127:120], plaintext[95:88], plaintext[63:56], plaintext[31:24],  
                    plaintext[119:112], plaintext[87:80], plaintext[55:48], plaintext[23:16],  
                    plaintext[111:104], plaintext[79:72], plaintext[47:40], plaintext[15:8],  
                    plaintext[103:96], plaintext[71:64], plaintext[39:32], plaintext[7:0]};  

    // AddRoundKey operation  
    ciphertext = shifted_rows ^ key;  
  end  
endmodule