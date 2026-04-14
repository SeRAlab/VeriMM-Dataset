module top_module(clk,nrst,ena,word);input clk; 
  input nrst; 
  input ena; 
  output reg [11:0] word; 
  always @(posedge clk or negedge nrst) begin 
  if(~nrst) begin 
  word <= 12'b101001101011; 
  end 
  else if(ena) begin 
  word[11] <= word[0]; 
  word[10] <= word[11]; 
  word[9] <= word[10]; 
  word[8] <= word[9]; 
  word[7] <= word[8]; 
  word[6] <= word[7]; 
  word[5] <= word[6] ^ word[0]; 
  word[4] <= word[5]; 
  word[3] <= word[4] ^ word[0]; 
  word[2] <= word[3]; 
  word[1] <= word[2]; 
  word[0] <= word[1] ^ word[0]; 
  end 
  end 
 endmodule