module top_module(input clk_i,input fdc_motor_i,input fdc_activity_i,output led_o);reg [20:0] cntr = 0; 
  reg [1:0] cycle = 0; 
  always @(posedge clk_i) 
  begin 
  if( fdc_activity_i == 1 ) 
  cntr = 1; 
  else 
  if( cntr > 0 ) cntr = cntr + 1'b1; 
  end 
  always @(posedge clk_i) cycle <= cycle + 1'b1; 
  assign led_o = (cntr > 0) | (fdc_motor_i && (cycle == 2'd0)); 
 endmodule