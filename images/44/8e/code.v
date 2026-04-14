module top_module(input clk,input rst,input i_wbs_we,input i_wbs_cyc,input [3:0] i_wbs_sel,input [31:0] i_wbs_dat,input i_wbs_stb,output reg o_wbs_ack,output reg [31:0] o_wbs_dat,input [31:0] i_wbs_adr,output reg o_wbs_int);localparam ADDR_0 = 32'h00000000; 
 localparam ADDR_1 = 32'h00000001; 
 localparam ADDR_2 = 32'h00000002; 
 always @ (posedge clk) begin 
  if (rst) begin 
  o_wbs_dat <= 32'h0; 
  o_wbs_ack <= 0; 
  o_wbs_int <= 0; 
  end 
  else begin 
  if (o_wbs_ack && ~i_wbs_stb)begin 
  o_wbs_ack <= 0; 
  end 
  if (i_wbs_stb && i_wbs_cyc) begin 
  if (!o_wbs_ack) begin 
  if (i_wbs_we) begin 
  case (i_wbs_adr) 
  24'h0000FF: begin 
  o_wbs_int <= 0; 
  end 
  24'h001000: begin 
  o_wbs_int <= i_wbs_dat[0]; 
  end 
  default: begin 
  end 
  endcase 
  end 
  else begin 
  o_wbs_dat <= i_wbs_adr; 
  end 
  o_wbs_ack <= 1; 
  end 
  end 
  end 
 end 
 endmodule