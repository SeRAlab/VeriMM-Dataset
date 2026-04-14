module top_module(input eai_csr_valid,output eai_csr_ready,input [31:0] eai_csr_addr,input eai_csr_wr,input [31:0] eai_csr_wdata,output [31:0] eai_csr_rdata,input clk,input rst_n);assign eai_csr_ready = 1'b1; 
  assign eai_csr_rdata = 32'b0; 
 endmodule