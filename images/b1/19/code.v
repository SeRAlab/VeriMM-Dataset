module top_module(mi_dout, edma_access, edma_packet,reset, clk, mi_en, mi_we, mi_addr, mi_din, edma_wait);parameter RFAW = 6; 
  parameter AW = 32; 
  parameter DW = 32; 
  parameter PW = 104; 
  input reset; 
  input clk; 
  input mi_en; 
  input mi_we; 
  input [RFAW+1:0] mi_addr; 
  input [63:0] mi_din; 
  output [31:0] mi_dout; 
  output edma_access; 
  output [PW-1:0] edma_packet; 
  input edma_wait; 
  assign edma_access=1'b0; 
  assign edma_packet='d0; 
  assign mi_dout='d0; 
 endmodule