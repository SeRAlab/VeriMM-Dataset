module top_module(input wire [15:0] din,output wire [15:0] dout,input wire clk,input wire reset,input wire bclk,input wire [1:0] cs,input wire [18:16] hi_addr,input wire lba,input wire oe,input wire rw,output wire rb_wait,input nram_clk,input [15:0] nram_a,input [7:0] nram_din,output [7:0] nram_dout,input nram_we);reg bus_write; 
  reg rw_del; 
  reg lba_del; 
  reg [18:0] bus_addr; 
  reg [15:0] bus_data; 
  reg [15:0] din_r; 
  reg rw_r; 
  reg cs0_r; 
  reg [18:0] addr_r; 
  reg lba_r; 
  always @(posedge bclk) begin 
  addr_r <= {hi_addr, din}; 
  cs0_r <= cs[0]; 
  rw_r <= rw; 
  din_r <= din; 
  lba_r <= lba; 
  end 
  always @(posedge bclk) begin 
  if( !lba ) begin 
  bus_addr <= {hi_addr, din}; 
  end else begin 
  bus_addr <= bus_addr; 
  end 
  end 
  assign rb_wait = 1'b1; 
 endmodule