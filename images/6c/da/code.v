module top_module(
  PERun_wen, act_out_Push_mioi_oswt, act_out_Push_mioi_biwt, act_out_Push_mioi_bdwt,
      act_out_Push_mioi_bcwt, act_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct,
      act_out_Push_mioi_ccs_ccore_done_sync_vld, act_out_Push_mioi_oswt_pff
);input PERun_wen;
  input act_out_Push_mioi_oswt;
  output act_out_Push_mioi_biwt;
  output act_out_Push_mioi_bdwt;
  input act_out_Push_mioi_bcwt;
  output act_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
  input act_out_Push_mioi_ccs_ccore_done_sync_vld;
  input act_out_Push_mioi_oswt_pff;



  
  assign act_out_Push_mioi_bdwt = act_out_Push_mioi_oswt & PERun_wen;
  assign act_out_Push_mioi_biwt = act_out_Push_mioi_oswt & (~ act_out_Push_mioi_bcwt)
      & act_out_Push_mioi_ccs_ccore_done_sync_vld;
  assign act_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct = act_out_Push_mioi_oswt_pff
      & PERun_wen;endmodule