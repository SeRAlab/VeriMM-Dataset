module top_module(clk, ar, sr, q);input clk, ar; 
  output q; 
  output reg [7:0] sr; 
  wire polynomial; 
  assign polynomial = sr[7]^sr[5]^sr[4]^sr[3]; 
  assign q = sr[7]; 
  always @ (posedge clk or negedge ar) 
  begin 
  if(~ar) 
  begin 
  sr <= 8'b00000001; 
  end 
  else 
  begin 
  sr <= { sr[6:0], polynomial }; 
  end 
  end 
 endmodule