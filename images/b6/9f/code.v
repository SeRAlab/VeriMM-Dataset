module top_module(
  input clk,
  input valid,
  input [15:0] data,
  output reg valid_out,            // Change to reg
  output reg [15:0] data_out,     // Change to reg
  input dcfilt_enb,
  input [15:0] dcfilt_coeff,
  input [15:0] dcfilt_offset
);// internal registers
  reg valid_d = 1'b0;
  reg [15:0] data_d = 16'h0000;
  reg valid_2d = 1'b0;
  reg [15:0] data_2d = 16'h0000;
  reg [15:0] dc_offset = 16'h0000;
  
  // DC offset calculation
  always @(posedge clk) begin
    if (valid == 1'b1) begin
      dc_offset <= (dcfilt_coeff * data + (65535 - dcfilt_coeff) * dc_offset) >> 16;
    end
  end
  
  // cancelling the DC offset
  always @(posedge clk) begin
    valid_d <= valid;
    data_d <= data + dcfilt_offset;
    valid_2d <= valid_d;
    data_2d <= data_d - dc_offset;
    if (dcfilt_enb == 1'b1) begin
      valid_out <= valid_2d;
      data_out <= data_2d;
    end else begin
      valid_out <= valid_d;
      data_out <= data_d;
    end
  end
endmodule