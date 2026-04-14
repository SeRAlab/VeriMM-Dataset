module top_module(input clk, input reset,
    input  io_out_0_ready,
    output io_out_0_valid,
    output[31:0] io_out_0_bits,
    output[4:0] io_out_0_tag,
    input  io_out_1_ready,
    output io_out_1_valid,
    output[31:0] io_out_1_bits,
    output[4:0] io_out_1_tag,
    output io_in_ready,
    input  io_in_valid,
    input [31:0] io_in_bits,
    input [4:0] io_in_tag,
    output io_chosen);wire T0;
  wire T1;
  wire T2;
  wire T3;
  wire T4;
  wire T5;
  reg[0:0] last_grant;
  wire T6;
  wire T7;
  wire T8;
  wire T9;
  wire T10;
  wire T11;
  wire T12;
  wire T13;
  wire T14;
  wire T15;
  wire T16;
  wire T17;
  wire T18;
  wire choose;
  wire T19;
  wire T20;
  wire T21;
  wire T22;

  assign io_out_0_valid = T0;
  assign T0 = T1 && io_in_valid;
  assign T1 = T22 || T2;
  assign T2 = ! T3;
  assign T3 = T13 || T4;
  assign T4 = io_out_1_ready && T5;
  assign T5 = 1'h1 > last_grant;
  assign T6 = io_in_valid && io_in_ready;
  assign io_in_ready = T7;
  assign T7 = io_out_0_ready || io_out_1_ready;
  assign io_out_1_valid = T8;
  assign T8 = T9 && io_in_valid;
  assign T9 = T15 || T10;
  assign T10 = ! T11;
  assign T11 = T12 || io_out_0_ready;
  assign T12 = T13 || T4;
  assign T13 = io_out_0_ready && T14;
  assign T14 = 1'h0 > last_grant;
  assign T15 = T17 && T16;
  assign T16 = 1'h1 > last_grant;
  assign T17 = ! T13;
  assign T18 = T6 ? choose : last_grant;
  assign choose = T20 ? 1'h1 : T19;
  assign T19 = io_out_0_ready ? 1'h0 : 1'h1;
  assign T20 = io_out_1_ready && T21;
  assign T21 = 1'h1 > last_grant;
  assign T22 = 1'h0 > last_grant;
  assign io_out_1_tag = io_in_tag;
  assign io_out_0_tag = io_in_tag;
  assign io_out_1_bits = io_in_bits;
  assign io_out_0_bits = io_in_bits;

  always @(posedge clk) begin
    if(reset) begin
      last_grant <= 1'h0;
    end else if(T6) begin
      last_grant <= T18;
    end
  end
endmodule