module top_module(div_clk,rst,time_value,contando, terminado);input div_clk; 
  input rst; 
  input contando; 
  input [3:0] time_value; 
  output reg terminado; 
  reg [3:0] contador; 
  always @(posedge div_clk or posedge rst) 
  begin 
  if(rst) 
  begin 
  contador <= 0; 
  terminado <= 0; 
  end 
  else 
  if(contando) 
  begin 
  if(contador == time_value) 
  begin 
  contador <= 0; 
  terminado <= 1; 
  end 
  else 
  begin 
  terminado <= 0; 
  contador <= contador + 1; 
  end 
  end 
  else 
  terminado <= 0; 
  end 
 endmodule