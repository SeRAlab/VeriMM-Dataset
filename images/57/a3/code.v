module top_module(
  clk,

  // control ports
  control,
  status,

  // FIFO interface
  src_adc_enable,
  src_adc_valid,
  src_adc_data,

  dst_adc_enable,
  dst_adc_valid,
  dst_adc_data
);localparam  RP_ID       = 8'hA0;
  parameter   CHANNEL_ID  = 0;

  input             clk;

  input   [31:0]    control;
  output  [31:0]    status;

  input             src_adc_enable;
  input             src_adc_valid;
  input   [15:0]    src_adc_data;

  output            dst_adc_enable;
  output            dst_adc_valid;
  output  [15:0]    dst_adc_data;

  reg               dst_adc_enable;
  reg               dst_adc_valid;
  reg     [15:0]    dst_adc_data;

  assign status = {24'h0, RP_ID};

  always @(posedge clk) begin
    dst_adc_enable <= src_adc_enable;
    dst_adc_valid <= src_adc_valid;
    dst_adc_data <= src_adc_data;
  end
endmodule