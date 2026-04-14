module top_module(
  PERun_wen, PERun_wten, act_in_PopNB_mioi_oswt, act_in_PopNB_mioi_biwt, act_in_PopNB_mioi_bdwt,
      act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct, act_in_PopNB_mioi_oswt_pff
);input PERun_wen;
  input PERun_wten;
  input act_in_PopNB_mioi_oswt;
  output act_in_PopNB_mioi_biwt;
  output act_in_PopNB_mioi_bdwt;
  output act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct;
  input act_in_PopNB_mioi_oswt_pff;



  
  assign act_in_PopNB_mioi_bdwt = act_in_PopNB_mioi_oswt & PERun_wen;
  assign act_in_PopNB_mioi_biwt = (~ PERun_wten) & act_in_PopNB_mioi_oswt;
  assign act_in_PopNB_mioi_ccs_ccore_start_rsc_dat_PERun_sct = act_in_PopNB_mioi_oswt_pff
      & PERun_wen;endmodule