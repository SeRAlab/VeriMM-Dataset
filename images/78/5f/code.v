module top_module(readData,readEnable,address,clk,writeEnable,writeData);parameter addresses = 32; 
  parameter width = 8; 
  parameter muxFactor = 0; 
  localparam addressWidth =$clog2(addresses); 
  output [width-1:0] readData; 
  input readEnable; 
  input [addressWidth-1:0] address; 
  input clk; 
  input writeEnable; 
  input [width-1:0] writeData; 
  reg [width-1:0] mem [addresses-1:0]; 
  reg [width-1:0] readData; 
  initial 
  begin 
  $display("%m : simulation model of memory"); 
  end 
  always @(posedge clk) 
  begin 
  if (writeEnable) 
  begin 
  mem[address] <= writeData; 
  end 
  else if(readEnable) 
  begin 
  readData <= mem[address]; 
  end 
  end 
 endmodule