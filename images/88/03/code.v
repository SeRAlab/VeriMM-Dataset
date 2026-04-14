module top_module(ENA_COMMA_ALIGN,RX_REC_CLK,ENA_CALIGN_REC);`define DLY #1 
  input ENA_COMMA_ALIGN; 
  input RX_REC_CLK; 
  output ENA_CALIGN_REC; 
  reg [0:1] phase_align_flops_r; 
  always @(posedge RX_REC_CLK) 
  begin 
  phase_align_flops_r[0] <= `DLY ENA_COMMA_ALIGN; 
  phase_align_flops_r[1] <= `DLY phase_align_flops_r[0]; 
  end 
  assign ENA_CALIGN_REC = phase_align_flops_r[1]; 
 endmodule