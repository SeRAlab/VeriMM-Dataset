module top_module(
  input           rx_clk,
  input  [127:0]  rx_data,
  output          adc_clk,
  input           adc_rst,
  output  [55:0]  adc_data_a,
  output  [55:0]  adc_data_b,
  output          adc_or_a,
  output          adc_or_b,
  output reg      adc_status  // Change to output reg
);wire    [15:0]  adc_data_a_s3_s;
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

  assign adc_data_a = { adc_data_a_s3_s[13:0], adc_data_a_s2_s[13:0],
                        adc_data_a_s1_s[13:0], adc_data_a_s0_s[13:0]};

  assign adc_data_b = { adc_data_b_s3_s[13:0], adc_data_b_s2_s[13:0],
                        adc_data_b_s1_s[13:0], adc_data_b_s0_s[13:0]};

  assign adc_data_a_s3_s = {rx_data[ 57: 56], rx_data[ 31: 24], rx_data[ 63: 58]};
  assign adc_data_a_s2_s = {rx_data[ 49: 48], rx_data[ 23: 16], rx_data[ 55: 50]};
  assign adc_data_a_s1_s = {rx_data[ 41: 40], rx_data[ 15:  8], rx_data[ 47: 42]};
  assign adc_data_a_s0_s = {rx_data[ 33: 32], rx_data[  7:  0], rx_data[ 39: 34]};

  assign adc_data_b_s3_s = {rx_data[121:120], rx_data[ 95: 88], rx_data[127:122]};
  assign adc_data_b_s2_s = {rx_data[113:112], rx_data[ 87: 80], rx_data[119:114]};
  assign adc_data_b_s1_s = {rx_data[105:104], rx_data[ 79: 72], rx_data[111:106]};
  assign adc_data_b_s0_s = {rx_data[ 97: 96], rx_data[ 71: 64], rx_data[103: 98]};

  always @(posedge rx_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status <= 1'b0;
    end else begin
      adc_status <= 1'b1;
    end
  end

endmodule