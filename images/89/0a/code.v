module top_module(input clk,input [7:0] index,output reg [3:0] red,output reg [3:0] green,output reg [3:0] blue,input write,input [1:0] read_data_cycle,input [7:0] read_data_register,output reg [3:0] read_data,input [1:0] write_data_cycle,input [7:0] write_data_register,input [3:0] write_data);reg [3:0] red_dac [0:255]; 
  reg [3:0] green_dac [0:255]; 
  reg [3:0] blue_dac [0:255]; 
  always @(posedge clk) 
  begin 
  red <= red_dac[index]; 
  green <= green_dac[index]; 
  blue <= blue_dac[index]; 
  end 
  always @(posedge clk) 
  case (read_data_cycle) 
  2'b00: read_data <= red_dac[read_data_register]; 
  2'b01: read_data <= green_dac[read_data_register]; 
  2'b10: read_data <= blue_dac[read_data_register]; 
  default: read_data <= 4'h0; 
  endcase 
  always @(posedge clk) 
  if (write) 
  case (write_data_cycle) 
  2'b00: red_dac[write_data_register] <= write_data; 
  2'b01: green_dac[write_data_register] <= write_data; 
  2'b10: blue_dac[write_data_register] <= write_data; 
  endcase 
 endmodule