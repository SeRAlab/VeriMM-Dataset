module top_module(input wire clk_sys,input wire rst,input wire ao486_rst,input wire [31:0] hdd_avalon_master_address,input wire hdd_avalon_master_read,output wire [31:0] hdd_avalon_master_readdata,input wire hdd_avalon_master_write,input wire [31:0] hdd_avalon_master_writedata,output wire hdd_avalon_master_waitrequest,output reg hdd_avalon_master_readdatavalid,input wire [31:0] bios_loader_address,input wire bios_loader_read,output wire [31:0] bios_loader_readdata,input wire bios_loader_write,input wire [31:0] bios_loader_writedata,output wire bios_loader_waitrequest,input wire [3:0] bios_loader_byteenable,output wire [1:0] driver_sd_avs_address,output wire driver_sd_avs_read,input wire [31:0] driver_sd_avs_readdata,output wire driver_sd_avs_write,output wire [31:0] driver_sd_avs_writedata);assign driver_sd_avs_address = (~ao486_rst) ? hdd_avalon_master_address[3:2] : bios_loader_address[3:2]; 
  assign driver_sd_avs_read = (~ao486_rst) ? hdd_avalon_master_read : bios_loader_read && bios_loader_address[31:4] == 28'h0; 
  assign driver_sd_avs_write = (~ao486_rst) ? hdd_avalon_master_write : bios_loader_write && bios_loader_address[31:4] == 28'h0; 
  assign driver_sd_avs_writedata = (~ao486_rst) ? hdd_avalon_master_writedata : bios_loader_writedata; 
  assign hdd_avalon_master_readdata = (~ao486_rst) ? driver_sd_avs_readdata : 0; 
  assign hdd_avalon_master_waitrequest = 0; 
  always @(posedge clk_sys) hdd_avalon_master_readdatavalid <= (~ao486_rst) ? driver_sd_avs_read : 0; 
  assign bios_loader_readdata = (~ao486_rst) ? 0 : driver_sd_avs_readdata; 
  assign bios_loader_waitrequest = 0; 
 endmodule