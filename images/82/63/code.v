module top_module(
  input           hdmi_clk,
  input           hdmi_sof,
  input           hdmi_de,
  input   [15:0]  hdmi_data,
  output reg      hdmi_tpm_oos
);reg     [15:0]  hdmi_tpm_data = 'd0;
  reg             hdmi_tpm_lr_mismatch = 'd0;
  reg             hdmi_tpm_fr_mismatch = 'd0;

  // Limited range
  wire [15:0] limited_tpm_data;
  assign limited_tpm_data[15:8] = (hdmi_data[15:8] < 8'h10) ? 8'h10 :
    ((hdmi_data[15:8] > 8'heb) ? 8'heb : hdmi_data[15:8]);
  assign limited_tpm_data[ 7:0] = (hdmi_data[ 7:0] < 8'h10) ? 8'h10 :
    ((hdmi_data[ 7:0] > 8'heb) ? 8'heb : hdmi_data[ 7:0]);
  wire lr_mismatch = (limited_tpm_data != hdmi_data);

  // Full range
  wire [15:0] full_tpm_data;
  assign full_tpm_data[15:8] = (hdmi_data[15:8] < 8'h01) ? 8'h01 :
    ((hdmi_data[15:8] > 8'hfe) ? 8'hfe : hdmi_data[15:8]);
  assign full_tpm_data[ 7:0] = (hdmi_data[ 7:0] < 8'h01) ? 8'h01 :
    ((hdmi_data[ 7:0] > 8'hfe) ? 8'hfe : hdmi_data[ 7:0]);
  wire fr_mismatch = (full_tpm_data != hdmi_data);

  always @(posedge hdmi_clk) begin
    if (hdmi_sof == 1'b1) begin
      hdmi_tpm_data <= 16'd0;
      hdmi_tpm_lr_mismatch <= 1'd0;
      hdmi_tpm_fr_mismatch <= 1'd0;
      hdmi_tpm_oos <= 1'b0;
    end else if (hdmi_de == 1'b1) begin
      hdmi_tpm_data <= hdmi_tpm_data + 1'b1;
      hdmi_tpm_lr_mismatch <= lr_mismatch;
      hdmi_tpm_fr_mismatch <= fr_mismatch;
      hdmi_tpm_oos <= hdmi_tpm_lr_mismatch | hdmi_tpm_fr_mismatch;
    end
  end

endmodule