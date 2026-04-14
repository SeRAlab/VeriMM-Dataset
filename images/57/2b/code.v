module top_module(input clk,input rst,input i_read_rdy,output reg o_read_act,input [23:0] i_read_size,input [24:0] i_read_data,output reg o_read_stb,output reg [7:0] o_red,output reg [7:0] o_green,output reg [7:0] o_blue,output reg o_pixel_rdy,input i_pixel_stb,input i_tp_red,input i_tp_blue,input i_tp_green,output reg o_last);reg [7:0] r_next_red; 
 reg [7:0] r_next_green; 
 reg [7:0] r_next_blue; 
 reg [31:0] r_read_count; 
 reg r_tp_green; 
 reg r_tp_blue; 
 always @ (posedge clk) begin 
  o_read_stb <= 0; 
  o_pixel_rdy <= 0; 
  if (rst) begin 
  o_read_act <= 0; 
  o_red <= 0; 
  o_green <= 0; 
  o_blue <= 0; 
  r_next_red <= 0; 
  r_next_green <= 0; 
  r_next_blue <= 0; 
  o_last <= 0; 
  end 
  else begin 
  if (i_read_rdy && !o_read_act) begin 
  r_read_count <= 0; 
  o_read_act <= 1; 
  end 
  if (o_pixel_rdy) begin 
  if (i_pixel_stb) begin 
  o_pixel_rdy <= 0; 
  o_red <= i_read_data[23:16]; 
  o_green <= i_read_data[15:8]; 
  o_blue <= i_read_data[7:0]; 
  o_last <= i_read_data[24]; 
  end 
  end 
  if (o_read_act) begin 
  o_pixel_rdy <= 1; 
  if (r_read_count < i_read_size) begin 
  if (i_pixel_stb) begin 
  r_read_count <= r_read_count + 1; 
  o_read_stb <= 1; 
  end 
  end 
  else begin 
  o_read_act <= 0; 
  end 
  end 
  end 
 end 
 endmodule