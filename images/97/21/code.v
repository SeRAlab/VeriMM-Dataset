module top_module(m_axi_araddr,
    si_rs_arvalid,
    m_payload_i_reg,
    m_valid_i_reg,
    aclk,
    sel_first,
    E,
    Q,
    S,
    D,
    O,
    r_rlast,
    m_axi_arready);input [11:0]m_axi_araddr;
  input si_rs_arvalid;
  input [47:0]m_payload_i_reg;
  input m_valid_i_reg;
  input aclk;
  output sel_first;
  output E;
  output [19:0]Q;
  output [3:0]S;
  output [3:0]D;
  output [3:0]O;
  output r_rlast;
  output m_axi_arready;

  assign sel_first = m_axi_araddr[0];
  assign E = si_rs_arvalid ? m_payload_i_reg[47] : 1'b0;
  assign Q = {m_axi_araddr[11:7], m_axi_araddr[3:1], m_axi_araddr[6], m_axi_araddr[4:0]};
  assign S = m_payload_i_reg[7:4];
  assign D = m_payload_i_reg[3:0];
  assign O = Q[15];
  assign r_rlast = s_axburst_eq0 & Q[15] & s_axburst_eq1;
  assign m_axi_arready = sel_first & si_rs_arvalid;

  wire s_axburst_eq0 = Q[2] & ~Q[1] & ~Q[0];
  wire s_axburst_eq1 = Q[2] & ~Q[1] & Q[0];

endmodule