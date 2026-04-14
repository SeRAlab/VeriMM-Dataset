module top_module(
    // inputs:
    input [8:0] address,
    input clk,
    input debugaccess,
    input monitor_error,
    input monitor_go,
    input monitor_ready,
    input reset_n,
    input write,
    input [31:0] writedata,

    // outputs:
    output reg [31:0] oci_ienable,          // Changed to 'reg'
    output reg [31:0] oci_reg_readdata,     // Changed to 'reg'
    output reg oci_single_step_mode,         // Changed to 'reg'
    output ocireg_ers,
    output ocireg_mrs,
    output take_action_ocireg
);wire oci_reg_00_addressed = (address == 9'h100);
  wire oci_reg_01_addressed = (address == 9'h101);
  wire write_strobe = (write & debugaccess);

  assign take_action_ocireg = (write_strobe & oci_reg_00_addressed);
  assign ocireg_ers = writedata[1];
  assign ocireg_mrs = writedata[0];

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      oci_single_step_mode <= 1'b0;
    end else if (take_action_ocireg) begin
      oci_single_step_mode <= writedata[3];
    end
  end

  wire take_action_oci_intr_mask_reg = (write_strobe & oci_reg_01_addressed); // Fixed omission of 'wire'

  always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
      oci_ienable <= 32'b00000000000000000000000000000011;
    end else if (take_action_oci_intr_mask_reg) begin
      oci_ienable <= writedata;
    end
  end

  always @(*) begin
    oci_reg_readdata = (oci_reg_00_addressed) ? {28'b0, oci_single_step_mode, monitor_go, monitor_ready, monitor_error} :
                           (oci_reg_01_addressed) ? oci_ienable : 32'b0;
  end

endmodule