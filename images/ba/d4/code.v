module top_module(clk,data,we,addr,out);`define ADDR_WIDTH_21_8 8 
 `define DATA_WIDTH_21_8 21 
  input clk; 
  input [`DATA_WIDTH_21_8-1:0] data; 
  input we; 
  input [`ADDR_WIDTH_21_8-1:0] addr; 
  output [`DATA_WIDTH_21_8-1:0] out; 
  reg [`DATA_WIDTH_21_8-1:0] out; 
  reg [`DATA_WIDTH_21_8-1:0] RAM[255:0]; 
  always @ (posedge clk) 
  begin 
  if (we) 
  begin 
  RAM[addr] <= data; 
  out <= RAM[addr]; 
  end 
  end 
 endmodule