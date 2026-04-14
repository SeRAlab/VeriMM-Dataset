module top_module(
  input wire [3:0] qspi_ui_dq_i,
  output wire qspi_cs,
  output wire [3:0] qspi_ui_dq_o,
  output wire [3:0] qspi_ui_dq_oe,
  output wire dut_io_pads_qspi_dq_0_i_ival,
  output wire dut_io_pads_qspi_dq_1_i_ival,
  output wire dut_io_pads_qspi_dq_2_i_ival,
  output wire dut_io_pads_qspi_dq_3_i_ival,
  output wire qspi_sck
);// Assign reasonable values to otherwise unconnected inputs to chip top
  wire reset_periph = 1'b0;
  wire slowclk = 1'b1;

  // Assuming these are declared in another part of the design
  // Replace with correct declarations as needed
  wire dut_io_pads_qspi_cs_0_o_oval;
  wire dut_io_pads_qspi_dq_3_o_oval;
  wire dut_io_pads_qspi_dq_2_o_oval;
  wire dut_io_pads_qspi_dq_1_o_oval;
  wire dut_io_pads_qspi_dq_0_o_oval;
  wire dut_io_pads_qspi_dq_3_o_oe;
  wire dut_io_pads_qspi_dq_2_o_oe;
  wire dut_io_pads_qspi_dq_1_o_oe;
  wire dut_io_pads_qspi_dq_0_o_oe;
  wire dut_io_pads_qspi_sck_o_oval;

  assign qspi_cs = dut_io_pads_qspi_cs_0_o_oval;
  assign qspi_ui_dq_o = {
    dut_io_pads_qspi_dq_3_o_oval,
    dut_io_pads_qspi_dq_2_o_oval,
    dut_io_pads_qspi_dq_1_o_oval,
    dut_io_pads_qspi_dq_0_o_oval
  };
  assign qspi_ui_dq_oe = {
    dut_io_pads_qspi_dq_3_o_oe,
    dut_io_pads_qspi_dq_2_o_oe,
    dut_io_pads_qspi_dq_1_o_oe,
    dut_io_pads_qspi_dq_0_o_oe
  };
  assign dut_io_pads_qspi_dq_0_i_ival = qspi_ui_dq_i[0];
  assign dut_io_pads_qspi_dq_1_i_ival = qspi_ui_dq_i[1];
  assign dut_io_pads_qspi_dq_2_i_ival = qspi_ui_dq_i[2];
  assign dut_io_pads_qspi_dq_3_i_ival = qspi_ui_dq_i[3];
  assign qspi_sck = dut_io_pads_qspi_sck_o_oval;

endmodule