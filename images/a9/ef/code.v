module top_module(
  PERun_wen, weight_out_Push_mioi_oswt, weight_out_Push_mioi_biwt, weight_out_Push_mioi_bdwt,
      weight_out_Push_mioi_bcwt, weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct,
      weight_out_Push_mioi_ccs_ccore_done_sync_vld, weight_out_Push_mioi_oswt_pff
);input PERun_wen;
  input weight_out_Push_mioi_oswt;
  output weight_out_Push_mioi_biwt;
  output weight_out_Push_mioi_bdwt;
  input weight_out_Push_mioi_bcwt;
  output weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
  input weight_out_Push_mioi_ccs_ccore_done_sync_vld;
  input weight_out_Push_mioi_oswt_pff;



  
  assign weight_out_Push_mioi_bdwt = weight_out_Push_mioi_oswt & PERun_wen;
  assign weight_out_Push_mioi_biwt = weight_out_Push_mioi_oswt & (~ weight_out_Push_mioi_bcwt)
      & weight_out_Push_mioi_ccs_ccore_done_sync_vld;
  assign weight_out_Push_mioi_ccs_ccore_start_rsc_dat_PERun_sct = weight_out_Push_mioi_oswt_pff
      & PERun_wen;endmodule