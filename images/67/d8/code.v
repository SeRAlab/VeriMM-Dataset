module top_module(
   // Outputs
   output reg arbpc0_pcxdp_grant_pa, 
   output reg arbpc0_pcxdp_q0_hold_pa_l, 
   output reg arbpc0_pcxdp_qsel0_pa, 
   output reg arbpc0_pcxdp_qsel1_pa_l, 
   output reg arbpc0_pcxdp_shift_px, 
   output reg arbpc2_pcxdp_grant_pa, 
   output reg arbpc2_pcxdp_q0_hold_pa_l, 
   output reg arbpc2_pcxdp_qsel0_pa, 
   output reg arbpc2_pcxdp_qsel1_pa_l, 
   output reg arbpc2_pcxdp_shift_px, 
   // Inputs
   input arbpc0_pcxdp_grant_arbbf_pa, 
   input arbpc0_pcxdp_q0_hold_arbbf_pa_l, 
   input arbpc0_pcxdp_qsel0_arbbf_pa, 
   input arbpc0_pcxdp_qsel1_arbbf_pa_l, 
   input arbpc0_pcxdp_shift_arbbf_px, 
   input arbpc2_pcxdp_grant_arbbf_pa, 
   input arbpc2_pcxdp_q0_hold_arbbf_pa_l, 
   input arbpc2_pcxdp_qsel0_arbbf_pa, 
   input arbpc2_pcxdp_qsel1_arbbf_pa_l, 
   input arbpc2_pcxdp_shift_arbbf_px
   );always @* begin
      arbpc0_pcxdp_grant_pa = arbpc0_pcxdp_grant_arbbf_pa;
      arbpc0_pcxdp_q0_hold_pa_l = arbpc0_pcxdp_q0_hold_arbbf_pa_l;
      arbpc0_pcxdp_qsel0_pa = arbpc0_pcxdp_qsel0_arbbf_pa;
      arbpc0_pcxdp_qsel1_pa_l = arbpc0_pcxdp_qsel1_arbbf_pa_l;
      arbpc0_pcxdp_shift_px = arbpc0_pcxdp_shift_arbbf_px;
      
      arbpc2_pcxdp_grant_pa = arbpc2_pcxdp_grant_arbbf_pa;
      arbpc2_pcxdp_q0_hold_pa_l = arbpc2_pcxdp_q0_hold_arbbf_pa_l;
      arbpc2_pcxdp_qsel0_pa = arbpc2_pcxdp_qsel0_arbbf_pa;
      arbpc2_pcxdp_qsel1_pa_l = arbpc2_pcxdp_qsel1_arbbf_pa_l;
      arbpc2_pcxdp_shift_px = arbpc2_pcxdp_shift_arbbf_px;
   end

endmodule