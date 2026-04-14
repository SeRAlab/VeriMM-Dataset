module top_module(
  PERun_wen, PERun_wten, accum_in_PopNB_mioi_oswt, accum_in_PopNB_mioi_biwt, accum_in_PopNB_mioi_bdwt,
      accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct, accum_in_PopNB_mioi_oswt_pff
);input PERun_wen;
  input PERun_wten;
  input accum_in_PopNB_mioi_oswt;
  output accum_in_PopNB_mioi_biwt;
  output accum_in_PopNB_mioi_bdwt;
  output accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
  input accum_in_PopNB_mioi_oswt_pff;



  
  assign accum_in_PopNB_mioi_bdwt = accum_in_PopNB_mioi_oswt & PERun_wen;
  assign accum_in_PopNB_mioi_biwt = (~ PERun_wten) & accum_in_PopNB_mioi_oswt;
  assign accum_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct = accum_in_PopNB_mioi_oswt_pff
      & PERun_wen;endmodule