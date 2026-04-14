module top_module(
  PERun_wen, accum_out_Push_mioi_oswt, accum_out_Push_mioi_biwt, accum_out_Push_mioi_bdwt,
      accum_out_Push_mioi_bcwt, accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct,
      accum_out_Push_mioi_ccs_ccore_done_sync_vld, accum_out_Push_mioi_oswt_pff
);input PERun_wen;
  input accum_out_Push_mioi_oswt;
  output accum_out_Push_mioi_biwt;
  output accum_out_Push_mioi_bdwt;
  input accum_out_Push_mioi_bcwt;
  output accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
  input accum_out_Push_mioi_ccs_ccore_done_sync_vld;
  input accum_out_Push_mioi_oswt_pff;



  
  assign accum_out_Push_mioi_bdwt = accum_out_Push_mioi_oswt & PERun_wen;
  assign accum_out_Push_mioi_biwt = accum_out_Push_mioi_oswt & (~ accum_out_Push_mioi_bcwt)
      & accum_out_Push_mioi_ccs_ccore_done_sync_vld;
  assign accum_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct = accum_out_Push_mioi_oswt_pff
      & PERun_wen;endmodule