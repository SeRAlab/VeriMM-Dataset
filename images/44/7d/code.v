module top_module(

  
  

  rx_clk,
  rx_data,

  

  adc_clk,
  adc_rst,
  adc_data_a,
  adc_data_b,
  adc_or_a,
  adc_or_b,
  adc_status);input           rx_clk;
  input  [127:0]  rx_data;

  

  output          adc_clk;
  input           adc_rst;
  output  [63:0]  adc_data_a;
  output  [63:0]  adc_data_b;
  output          adc_or_a;
  output          adc_or_b;
  output          adc_status;

  

  reg             adc_status = 'd0;

  

  wire    [15:0]  adc_data_a_s3_s;
  wire    [15:0]  adc_data_a_s2_s;
  wire    [15:0]  adc_data_a_s1_s;
  wire    [15:0]  adc_data_a_s0_s;
  wire    [15:0]  adc_data_b_s3_s;
  wire    [15:0]  adc_data_b_s2_s;
  wire    [15:0]  adc_data_b_s1_s;
  wire    [15:0]  adc_data_b_s0_s;

  

  assign adc_clk = rx_clk;
  assign adc_or_a = 1'b0;
  assign adc_or_b = 1'b0;

  

  assign adc_data_a = { adc_data_a_s3_s, adc_data_a_s2_s,
                        adc_data_a_s1_s, adc_data_a_s0_s};

  assign adc_data_b = { adc_data_b_s3_s, adc_data_b_s2_s,
                        adc_data_b_s1_s, adc_data_b_s0_s};

  

  assign adc_data_a_s3_s = {rx_data[ 31: 24], rx_data[ 63: 56]};
  assign adc_data_a_s2_s = {rx_data[ 23: 16], rx_data[ 55: 48]};
  assign adc_data_a_s1_s = {rx_data[ 15:  8], rx_data[ 47: 40]};
  assign adc_data_a_s0_s = {rx_data[  7:  0], rx_data[ 39: 32]};

  assign adc_data_b_s3_s = {rx_data[ 95: 88], rx_data[127:120]};
  assign adc_data_b_s2_s = {rx_data[ 87: 80], rx_data[119:112]};
  assign adc_data_b_s1_s = {rx_data[ 79: 72], rx_data[111:104]};
  assign adc_data_b_s0_s = {rx_data[ 71: 64], rx_data[103: 96]};

  

  always @(posedge rx_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status <= 1'b0;
    end else begin
      adc_status <= 1'b1;
    end
  end

endmodule