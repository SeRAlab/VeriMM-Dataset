module top_module(input clk, input reset,input io_out_0_ready,output io_out_0_valid,output io_out_0_bits_centeroidsFinished,output io_out_0_bits_pointsFinished,output[15:0] io_out_0_bits_centeroidIndex,output[63:0] io_out_0_bits_point_x,output[63:0] io_out_0_bits_point_y,output[63:0] io_out_0_bits_point_z,output[4:0] io_out_0_tag,output io_in_ready,input io_in_valid,input io_in_bits_centeroidsFinished,input io_in_bits_pointsFinished,input [15:0] io_in_bits_centeroidIndex,input [63:0] io_in_bits_point_x,input [63:0] io_in_bits_point_y,input [63:0] io_in_bits_point_z,input [4:0] io_in_tag,output io_chosen);wire T0; 
  wire T1; 
  wire T2; 
  wire T3; 
  wire T4; 
  reg[0:0] last_grant; 
  wire T5; 
  wire T6; 
  wire T7; 
  assign io_out_0_valid = T0; 
  assign T0 = T1 && io_in_valid; 
  assign io_in_ready = io_out_0_ready; 
  assign T1 = T7 || T2; 
  assign T2 = ! T3; 
  assign T3 = io_out_0_ready && T4; 
  assign T4 = 1'h0 > last_grant; 
  assign T5 = io_in_valid && io_in_ready; 
  assign T6 = T5 ? 1'h0 : last_grant; 
  assign T7 = 1'h0 > last_grant; 
  assign io_out_0_bits_pointsFinished = io_in_bits_pointsFinished; 
  assign io_out_0_bits_centeroidsFinished = io_in_bits_centeroidsFinished; 
  assign io_out_0_tag = io_in_tag; 
  always @(posedge clk) begin 
  if(reset) begin 
  last_grant <= 1'h0; 
  end else if(T5) begin 
  last_grant <= T6; 
  end 
  end 
 endmodule