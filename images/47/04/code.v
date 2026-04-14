module top_module(clk, en, ar, dig1, dig2, dig3);input clk, ar, en; 
  output reg [3:0] dig1, dig2, dig3; 
  wire dig1_carry, dig2_carry, dig3_carry; 
  assign dig1_carry = (dig1 == 4'd9); 
  assign dig2_carry = dig1_carry&(dig2 == 4'd9); 
  assign dig3_carry = dig2_carry&(dig3 == 4'd9); 
  always @ (posedge clk or negedge ar) 
  begin 
  if(~ar) 
  begin 
  dig1 <= 4'd0; 
  dig2 <= 4'd0; 
  dig3 <= 4'd0; 
  end else if(~dig3_carry&en) 
  begin 
  if(dig2_carry) 
  begin 
  dig3 <= dig3 + 1; 
  dig2 <= 0; 
  dig1 <= 0; 
  end else if(dig1_carry) 
  begin 
  dig2 <= dig2 + 1; 
  dig1 <= 0; 
  end else 
  begin 
  dig1 <= dig1 + 1; 
  end 
  end 
  end 
  endmodule