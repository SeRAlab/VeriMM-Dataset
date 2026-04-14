module top_module(pcx_spc_grant_bufpm_pa, pcx_stall_bufpm_pq,pcx_spc_grant_pa, pcx_stall_pq);output [4:0] pcx_spc_grant_bufpm_pa; 
  output pcx_stall_bufpm_pq; 
  input [4:0] pcx_spc_grant_pa; 
  input pcx_stall_pq; 
  assign pcx_spc_grant_bufpm_pa = pcx_spc_grant_pa; 
  assign pcx_stall_bufpm_pq = pcx_stall_pq; 
 endmodule