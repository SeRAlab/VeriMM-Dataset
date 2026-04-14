module top_module(q, d, cp, cdn);output q;
  input d;
  input cp;
  input cdn;

  reg qi;

  always @(posedge cp or negedge cdn) begin
    if (~cdn) qi <= 1'b0;
    else qi <= d;
  end
  buf (q, qi);

  specify
    specparam tpd_cp_q_lh = 6;
    specparam tpd_cp_q_hl = 7;
    specparam tpd_cdn_q_lh = 0;
    specparam tpd_cdn_q_hl = 3;

    if (cdn) (posedge cp => (q +: d)) = (tpd_cp_q_lh, tpd_cp_q_hl);
    (negedge cdn => (q +: 1'b0)) = (tpd_cdn_q_lh, tpd_cdn_q_hl);
  endspecify
endmodule