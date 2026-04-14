module top_module(
  // jesd interface 
  // rx_clk is (line-rate/40)
  rx_clk,
  rx_data,

  // adc data output
  adc_clk,
  adc_rst,
  adc_data_a,
  adc_data_b,
  adc_or_a,
  adc_or_b,
  adc_status
);// jesd interface 
  // rx_clk is (line-rate/40)
  input rx_clk;
  input [63:0] rx_data;

  // adc data output
  output adc_clk;
  input adc_rst;
  output [31:0] adc_data_a;
  output [31:0] adc_data_b;
  output adc_or_a;
  output adc_or_b;
  output adc_status;

  // internal signals
  reg adc_status_reg = 1'b0;
  wire [15:0] adc_data_a_s1_s;
  wire [15:0] adc_data_a_s0_s;
  wire [15:0] adc_data_b_s1_s;
  wire [15:0] adc_data_b_s0_s;

  // adc clock is the reference clock
  assign adc_clk = rx_clk;
  assign adc_or_a = 1'b0;
  assign adc_or_b = 1'b0;

  // adc channels
  assign adc_data_a = {adc_data_a_s1_s, adc_data_a_s0_s};
  assign adc_data_b = {adc_data_b_s1_s, adc_data_b_s0_s};

  // data multiplex
  assign adc_data_a_s1_s = {rx_data[23:16], rx_data[31:24]};
  assign adc_data_a_s0_s = {rx_data[ 7: 0], rx_data[15: 8]};
  assign adc_data_b_s1_s = {rx_data[55:48], rx_data[63:56]}; 
  assign adc_data_b_s0_s = {rx_data[39:32], rx_data[47:40]};

  // status
  always @(posedge rx_clk) begin
    if (adc_rst == 1'b1) begin
      adc_status_reg <= 1'b0;
    end else begin
      adc_status_reg <= 1'b1;
    end
  end

  assign adc_status = adc_status_reg;

endmodule