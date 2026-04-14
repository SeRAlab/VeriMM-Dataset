module top_module(
  clk,

  
  control,
  status,

  
  src_adc_dwr,
  src_adc_dsync,
  src_adc_ddata,
  src_adc_dovf,

  dst_adc_dwr,
  dst_adc_dsync,
  dst_adc_ddata,
  dst_adc_dovf
);localparam  RP_ID       = 8'hA0;
  parameter   CHANNEL_ID  = 0;

  input             clk;

  input   [31:0]    control;
  output  [31:0]    status;

  input             src_adc_dwr;
  input             src_adc_dsync;
  input   [31:0]    src_adc_ddata;
  output            src_adc_dovf;

  output            dst_adc_dwr;
  output            dst_adc_dsync;
  output  [31:0]    dst_adc_ddata;
  input             dst_adc_dovf;

  reg               dst_adc_dwr;
  reg               dst_adc_dsync;
  reg     [31:0]    dst_adc_ddata;
  reg               src_adc_dovf;

  assign status = {24'h0, RP_ID};

  always @(posedge clk) begin
    dst_adc_dwr    <= src_adc_dwr;
    dst_adc_dsync  <= src_adc_dsync;
    dst_adc_ddata  <= src_adc_ddata;
    src_adc_dovf   <= dst_adc_dovf;
  end
endmodule