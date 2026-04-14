module top_module(input clk,input reset,input [15:0] xadc_data,input xadc_data_ready,input [4:0] channel,output reg [15:0] xadc_vaux0_data,output reg xadc_vaux0_ready,output reg [15:0] xadc_vaux8_data,output reg xadc_vaux8_ready);always @(posedge clk) begin 
  if (reset) begin 
  xadc_vaux0_data <= 16'd0; 
  xadc_vaux0_ready <= 1'b0; 
  end 
  else 
  if (xadc_data_ready && (channel == 5'h10)) begin 
  xadc_vaux0_data <= xadc_data; 
  xadc_vaux0_ready <= 1'b1; 
  end 
  else 
  xadc_vaux0_ready <= 1'b0; 
  end 
  always @(posedge clk) begin 
  if (reset) begin 
  xadc_vaux8_data <= 16'd0; 
  xadc_vaux8_ready <= 1'b0; 
  end 
  else 
  if (xadc_data_ready && (channel == 5'h18)) begin 
  xadc_vaux8_data <= xadc_data; 
  xadc_vaux8_ready <= 1'b1; 
  end 
  else 
  xadc_vaux8_ready <= 1'b0; 
  end 
 endmodule