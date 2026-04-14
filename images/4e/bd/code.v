module top_module(clk, reset, vga_h_sync, vga_v_sync, inDisplayArea, CounterX, CounterY);input clk, reset; 
 output vga_h_sync, vga_v_sync; 
 output inDisplayArea; 
 output [9:0] CounterX; 
 output [9:0] CounterY; 
 reg [9:0] CounterX; 
 reg [9:0] CounterY; 
 reg vga_HS, vga_VS; 
 reg inDisplayArea; 
 always @(posedge clk, posedge reset) 
  begin 
  if(reset) 
  CounterX <= 0; 
  else if(CounterX==10'h320) 
  CounterX <= 0; 
  else 
  CounterX <= CounterX + 1; 
  end 
 always @(posedge clk, posedge reset) 
  begin 
  if(reset) 
  CounterY<=0; 
  else if(CounterY==10'h209) 
  CounterY<=0; 
  else if(CounterX==10'h320) 
  CounterY <= CounterY + 1; 
  end 
 always @(posedge clk) 
  begin 
  vga_HS <= (CounterX > 655 && CounterX < 752); 
  vga_VS <= (CounterY == 490 || CounterY == 491); 
  end 
 always @(posedge clk, posedge reset) 
  if(reset) 
  inDisplayArea<=0; 
  else 
  inDisplayArea <= (CounterX<640) && (CounterY<480); 
 assign vga_h_sync = ~vga_HS; 
 assign vga_v_sync = ~vga_VS; 
 endmodule