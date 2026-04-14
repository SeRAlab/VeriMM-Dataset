module CSPRNG(clk, rst, seed, random_out);  
  input clk;  
  input rst;  
  input [4:0] seed;  
  output reg [4:0] random_out;  

  reg [4:0] lfsr;  
  wire feedback;  

  // Feedback polynomial for a 5-bit LFSR: x^5 + x^2 + 1  
  assign feedback = lfsr[4] ^ lfsr[2];  

  always @(posedge clk or posedge rst) begin  
    if (rst) begin  
      lfsr <= seed;  
      random_out <= seed;  
    end else begin  
      lfsr <= {lfsr[3:0], feedback};  
      random_out <= lfsr;  
    end  
  end  
endmodule