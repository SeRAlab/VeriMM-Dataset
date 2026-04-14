module top_module(EN, clk, R, H);input EN, clk; 
  input [3:0] R; 
  output reg [0:6] H; 
  reg [1:0] i; 
  reg [25:0]count; 
  initial begin 
  i <= 0; 
  end 
  always @ (posedge clk) 
  begin 
  if (R[i] & EN) begin 
  if (i == 3) 
  H = 7'b0000110; 
  else if (i == 2) 
  H = 7'b0010010; 
  else if (i == 1) 
  H = 7'b1001111; 
  else if (i == 0) 
  H = 7'b0000001; 
  end 
  else 
  H = 7'b1111110; 
  if (count == 9999999 | ~R[i]) 
  begin 
  count <= 0; 
  if (i == 3) 
  i <= 0; 
  else 
  i <= i + 1; 
  end 
  else 
  begin 
  count <= count + 1; 
  end 
  end 
 endmodule