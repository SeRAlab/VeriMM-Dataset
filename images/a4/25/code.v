module top_module(input wire clk,input wire [2:0] slave_address,output wire [31:0] slave_readdata,input wire slave_read,input wire slave_write,input wire [31:0] slave_writedata,input wire reset,output wire i2c_hs_read,output wire i2c_hs_write,output wire [2:0] i2c_hs_addr,input wire [31:0] i2c_hs_readdata,output wire [31:0] i2c_hs_writedata);assign slave_readdata = i2c_hs_readdata; 
  assign i2c_hs_writedata = slave_writedata; 
  assign i2c_hs_write = slave_write; 
  assign i2c_hs_read = slave_read; 
  assign i2c_hs_addr = slave_address; 
 endmodule