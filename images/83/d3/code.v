module top_module(input wire fclk,input wire rst_n,input wire zpos,input wire zneg,input wire [15:0] a,input wire mreq_n,input wire m1_n,input wire brk_ena,input wire [15:0] brk_addr,output reg imm_nmi);always @(posedge fclk, negedge rst_n) 
  if( !rst_n ) 
  imm_nmi <= 1'b0; 
  else if( zneg && !mreq_n && !m1_n && a==brk_addr && brk_ena && !imm_nmi ) 
  imm_nmi <= 1'b1; 
  else 
  imm_nmi <= 1'b0; 
 endmodule