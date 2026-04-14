module top_module(
  input wbck_i_valid,
  input wbck_i_err,
  input wbck_i_wdat,
  input wbck_i_flags,
  input wbck_i_rdfpu,
  input wbck_i_rdidx,
  input wbck_i_pc,
  output oitf_ret_ena
);wire need_wbck = 1'b1;
  wire longp_wbck_o_ready = 1'b1;
  wire need_excp = wbck_i_err;
  wire longp_excp_o_ready = 1'b1;

  assign wbck_i_ready = 
       (need_wbck ? longp_wbck_o_ready : 1'b1)
     & (need_excp ? longp_excp_o_ready : 1'b1);

  assign longp_wbck_o_valid = need_wbck & wbck_i_valid & (need_excp ? longp_excp_o_ready : 1'b1);
  assign longp_excp_o_valid = need_excp & wbck_i_valid & (need_wbck ? longp_wbck_o_ready : 1'b1);

  assign longp_wbck_o_wdat  = wbck_i_wdat ;
  assign longp_wbck_o_flags = wbck_i_flags ;
  assign longp_wbck_o_rdfpu = wbck_i_rdfpu ;
  assign longp_wbck_o_rdidx = wbck_i_rdidx;

  assign longp_excp_o_pc    = wbck_i_pc;

  assign oitf_ret_ena = wbck_i_valid & wbck_i_ready;

endmodule