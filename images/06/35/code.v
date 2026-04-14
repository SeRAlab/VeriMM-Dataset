module simple_DES(input [7:0] plaintext,  
                  input clk,  
                  input rst,  
                  output reg [7:0] ciphertext);  

  // Basic permutation table  
  reg [7:0] permuted;  
  always @(*) begin  
    permuted[0] = plaintext[3];  
    permuted[1] = plaintext[0];  
    permuted[2] = plaintext[2];  
    permuted[3] = plaintext[4];  
    permuted[4] = plaintext[7];  
    permuted[5] = plaintext[6];  
    permuted[6] = plaintext[1];  
    permuted[7] = plaintext[5];  
  end  

  // Simple substitution box (S-Box)  
  function [3:0] sbox;  
    input [3:0] in;  
    case(in)  
      4'b0000: sbox = 4'b0011;  
      4'b0001: sbox = 4'b0100;  
      4'b0010: sbox = 4'b0110;  
      4'b0011: sbox = 4'b1001;  
      4'b0100: sbox = 4'b1110;  
      4'b0101: sbox = 4'b1101;  
      4'b0110: sbox = 4'b1010;  
      4'b0111: sbox = 4'b0001;  
      default: sbox = 4'b0000;  
    endcase  
  endfunction  

  // Final output generation  
  always @(posedge clk or posedge rst) begin  
    if (rst)  
      ciphertext <= 8'b0;  
    else  
      ciphertext <= {sbox(permuted[7:4]), sbox(permuted[3:0])};  
  end  
endmodule