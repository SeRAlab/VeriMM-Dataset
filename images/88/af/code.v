module top_module(output [15 : 0] data_out,input write,input [15 : 0] address,input [15 : 0] data_in,output reg [15 : 0] LED_datmem);reg [15 : 0] memory [255 : 0]; 
  assign data_out = memory[address]; 
  always @(posedge write) 
  begin 
  if (address == 16'hBF00) 
  begin 
  LED_datmem <= data_in; 
  end 
  else 
  begin 
  memory[address] <= data_in; 
  end 
  end 
 endmodule