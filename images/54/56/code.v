module top_module(input clk_in,input rstn,input app_msi_req,output reg app_msi_ack,input[2:0] app_msi_tc,input[4:0] app_msi_num,input stream_ready,output reg [7:0] stream_data,output reg stream_valid);reg stream_ready_del; 
  reg app_msi_req_r; 
  wire [7:0] m_data; 
  assign m_data[7:5] = app_msi_tc[2:0]; 
  assign m_data[4:0] = app_msi_num[4:0]; 
  always @(negedge rstn or posedge clk_in) begin 
  if (rstn == 1'b0) 
  stream_ready_del <= 1'b0; 
  else 
  stream_ready_del <= stream_ready; 
  end 
  always @(negedge rstn or posedge clk_in) begin 
  if (rstn == 1'b0) begin 
  app_msi_ack <= 1'b0; 
  stream_valid <= 1'b0; 
  stream_data <= 8'h0; 
  app_msi_req_r <= 1'b0; 
  end 
  else begin 
  app_msi_ack <= stream_ready_del & app_msi_req; 
  stream_valid <= stream_ready_del & app_msi_req & ~app_msi_req_r; 
  stream_data <= m_data; 
  app_msi_req_r <= stream_ready_del ? app_msi_req : app_msi_req_r; 
  end 
  end 
 endmodule