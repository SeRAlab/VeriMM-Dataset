module top_module(
  PERun_wen, weight_in_PopNB_mioi_oswt, PERun_wten, weight_in_PopNB_mioi_biwt, weight_in_PopNB_mioi_bdwt,
      weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct, weight_in_PopNB_mioi_oswt_pff
);input PERun_wen;
  input weight_in_PopNB_mioi_oswt;
  input PERun_wten;
  output weight_in_PopNB_mioi_biwt;
  output weight_in_PopNB_mioi_bdwt;
  output weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
  input weight_in_PopNB_mioi_oswt_pff;



  
  assign weight_in_PopNB_mioi_bdwt = weight_in_PopNB_mioi_oswt & PERun_wen;
  assign weight_in_PopNB_mioi_biwt = (~ PERun_wten) & weight_in_PopNB_mioi_oswt;
  assign weight_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct = weight_in_PopNB_mioi_oswt_pff
      & PERun_wen;endmodule