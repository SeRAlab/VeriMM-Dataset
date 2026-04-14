module top_module(
  input wire m_valid_i_reg,
  input wire m_ready_d0,
  input wire s_axi_wready_i_reg,
  input wire grant_rnw_reg,
  input wire [2:0] m_axi_wready,
  input wire [2:0] m_atarget_enc,
  input wire [1:0] m_axi_awready,
  input wire [1:0] m_axi_bvalid,
  input wire [0:0] m_ready_d_reg_1_1,
  input wire [0:0] m_atarget_enc_reg_1,
  input wire [0:0] m_atarget_enc_reg_0,
  input wire grant_rnw_reg_0,
  input wire aclk,
  output wire m_valid_o, // Changed name to avoid conflict
  output wire [2:0] m_ready_d,
  output wire m_ready_d_reg_1_0,
  output wire m_ready_d_reg_2_0,
  output wire m_ready_d_reg_2_1,
  input wire s_axi_wlast
);wire [2:0] m_ready_d_internal;
  wire m_ready_d_reg_1_0_internal;
  wire m_ready_d_reg_2_0_internal;
  wire m_ready_d_reg_2_1_internal;

  // Splitter logic goes here

  assign m_ready_d = m_ready_d_internal;
  assign m_ready_d_reg_1_0 = m_ready_d_reg_1_0_internal;
  assign m_ready_d_reg_2_0 = m_ready_d_reg_2_0_internal;
  assign m_ready_d_reg_2_1 = m_ready_d_reg_2_1_internal;

endmodule