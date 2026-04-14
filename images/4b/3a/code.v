module top_module(pcx_spc_grant_bufpdr_pa,pcx_spc_grant_bufp3_pa_l);output [4:0] pcx_spc_grant_bufpdr_pa; 
  input [4:0] pcx_spc_grant_bufp3_pa_l; 
  assign pcx_spc_grant_bufpdr_pa = ~pcx_spc_grant_bufp3_pa_l; 
 endmodule