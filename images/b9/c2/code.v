module top_module(
 input atb0out,
 input atb1out,
 output atbcompout 
 );parameter lpm_type = "cyclonev_pll_aux";
parameter pl_aux_atb_atben0_precomp =  01'b1 ;
parameter pl_aux_atb_atben1_precomp =  01'b1 ;
parameter pl_aux_atb_comp_minus =  01'b0 ;
parameter pl_aux_atb_comp_plus =  01'b0 ;
parameter pl_aux_comp_pwr_dn =  01'b1 ;

assign atbcompout= 01'b0;

   

endmodule