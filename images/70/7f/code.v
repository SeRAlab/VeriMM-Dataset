module top_module(input clk,input rst,output reg vga_dump,input [31:0] addr_b,input [31:0] data_b_in,input [31:0] data_b_we);always @(posedge clk) 
  if (~rst) begin 
  vga_dump <= 0; 
  end else begin 
  if (vga_dump) begin 
  vga_dump <= 0; 
  end else if (addr_b == 65599 && data_b_we) begin 
  vga_dump <= 1; 
  end 
  end 
 endmodule