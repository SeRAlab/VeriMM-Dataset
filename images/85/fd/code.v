module top_module(clk, rst_n, Valid, FE_ID);input clk; 
  input rst_n; 
  input [7:0] Valid; 
  output reg [3:0] FE_ID; 
 always @(posedge clk or negedge rst_n) 
 begin 
  if(!rst_n) 
  begin 
  FE_ID <= 4'h0; 
  end 
  else 
  begin 
  casex(Valid) 
  8'bxxxx_xxx1:begin 
  FE_ID <= 4'h1; 
  end 
  8'bxxxx_xx10:begin 
  FE_ID <= 4'h2; 
  end 
  8'bxxxx_x100:begin 
  FE_ID <= 4'h3; 
  end 
  8'bxxxx_1000:begin 
  FE_ID <= 4'h4; 
  end 
  8'bxxx1_0000:begin 
  FE_ID <= 4'h5; 
  end 
  8'bxx10_0000:begin 
  FE_ID <= 4'h6; 
  end 
  8'bx100_0000:begin 
  FE_ID <= 4'h7; 
  end 
  8'b1000_0000:begin 
  FE_ID <= 4'h8; 
  end 
  default:begin 
  FE_ID <= 4'h0; 
  end 
  endcase 
  end 
 end 
 endmodule