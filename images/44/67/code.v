module top_module(input clk, input reset,
    input  io_out_ready,
    output io_out_valid,
    output io_out_bits_centeroidsFinished,
    output io_out_bits_pointsFinished,
    output[15:0] io_out_bits_centeroidIndex,
    output[63:0] io_out_bits_point_x,
    output[63:0] io_out_bits_point_y,
    output[63:0] io_out_bits_point_z,
    output[9:0] io_out_tag,
    output io_in_0_ready,
    input  io_in_0_valid,
    input  io_in_0_bits_centeroidsFinished,
    input  io_in_0_bits_pointsFinished,
    input [15:0] io_in_0_bits_centeroidIndex,
    input [63:0] io_in_0_bits_point_x,
    input [63:0] io_in_0_bits_point_y,
    input [63:0] io_in_0_bits_point_z,
    input [9:0] io_in_0_tag,
    output io_chosen);wire T0;
  wire[15:0] T1;
  wire[15:0] dvec_0_centeroidIndex;
  wire T2;
  wire T3;
  wire T4;
  wire T5;
  reg[0:0] last_grant;
  wire T6;
  wire T7;
  wire T8;
  wire[9:0] T9;
  wire[4:0] T10;
  wire[4:0] tvec_0;
  wire[4:0] T11;

  assign io_in_0_ready = T0;
  assign T0 = T2 && io_out_ready;
  assign io_out_valid = io_in_0_valid;
  assign io_out_bits_centeroidIndex = T1;
  assign T1 = dvec_0_centeroidIndex & 16'hffff;
  assign dvec_0_centeroidIndex = io_in_0_bits_centeroidIndex;
  assign T2 = T8 || T3;
  assign T3 = ! T4;
  assign T4 = io_in_0_valid && T5;
  assign T5 = 1'h0 > last_grant;
  assign T6 = io_out_valid && io_out_ready;
  assign T7 = T6 ? 1'h0 : last_grant;
  assign T8 = 1'h0 > last_grant;
  assign io_out_tag = T9;
  assign T9 = {5'h0, T10};
  assign T10 = tvec_0 & 5'h1f;
  assign tvec_0 = T11;
  assign T11 = io_in_0_tag[3'h4:1'h0];

  always @(posedge clk) begin
    if(reset) begin
      last_grant <= 1'h0;
    end else if(T6) begin
      last_grant <= T7;
    end
  end
endmodule