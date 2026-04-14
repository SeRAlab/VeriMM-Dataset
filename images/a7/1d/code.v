module top_module(
  input [8:0] address,
  input chipselect,
  input clk,
  input debugaccess,
  input monitor_error,
  input monitor_go,
  input monitor_ready,
  input reset_n,
  input write,
  input [31:0] writedata,
  output reg [31:0] oci_ienable,
  output reg [31:0] oci_reg_readdata,
  output reg oci_single_step_mode,
  output reg ocireg_ers,
  output reg ocireg_mrs,
  output reg take_action_ocireg
);wire oci_reg_00_addressed;
  wire oci_reg_01_addressed;
  wire ocireg_sstep;
  wire take_action_oci_intr_mask_reg;
  wire write_strobe;

  assign oci_reg_00_addressed = (address == 9'h100);
  assign oci_reg_01_addressed = (address == 9'h101);
  assign write_strobe = (chipselect & write & debugaccess);

  assign take_action_ocireg = (write_strobe & oci_reg_00_addressed);
  assign take_action_oci_intr_mask_reg = (write_strobe & oci_reg_01_addressed);

  assign ocireg_ers = writedata[1];
  assign ocireg_mrs = writedata[0];
  assign ocireg_sstep = writedata[3];

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      oci_single_step_mode <= 1'b0;
    end else if (take_action_ocireg) begin
      oci_single_step_mode <= ocireg_sstep;
    end
  end

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      oci_ienable <= 32'b0;
    end else if (take_action_oci_intr_mask_reg) begin
      oci_ienable <= writedata | ~(32'b0);
    end
  end

  always @(*) begin
    if (oci_reg_00_addressed) begin
      oci_reg_readdata = {28'b0, oci_single_step_mode, monitor_go, monitor_ready, monitor_error};
    end else if (oci_reg_01_addressed) begin
      oci_reg_readdata = oci_ienable;
    end else begin
      oci_reg_readdata = 32'b0;
    end
  end

endmodule