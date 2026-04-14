module top_module(input clk,input [3:0] attr,output reg [7:0] index,input [3:0] address,input write,output reg [7:0] read_data,input [7:0] write_data);reg [7:0] palette [0:15]; 
  always @(posedge clk) index <= palette[attr]; 
  always @(posedge clk) read_data <= palette[address]; 
  always @(posedge clk) 
  if (write) palette[address] <= write_data; 
 endmodule