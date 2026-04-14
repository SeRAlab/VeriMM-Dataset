module top_module(CLK_IN,reset,enb_1_2000_0,x,y);input CLK_IN; 
  input reset; 
  input enb_1_2000_0; 
  input signed [17:0] x; 
  output y; 
  reg signed [17:0] Delay_out1; 
  wire signed [18:0] Add_sub_cast; 
  wire signed [18:0] Add_sub_cast_1; 
  wire signed [18:0] Add_out1; 
  wire Compare_To_Zero2_out1; 
  always @(posedge CLK_IN) 
  begin : Delay_process 
  if (reset == 1'b1) begin 
  Delay_out1 <= 18'sb000000000000000000; 
  end 
  else if (enb_1_2000_0) begin 
  Delay_out1 <= x; 
  end 
  end 
  assign Add_sub_cast = x; 
  assign Add_sub_cast_1 = Delay_out1; 
  assign Add_out1 = Add_sub_cast - Add_sub_cast_1; 
 assign Compare_To_Zero2_out1 = (Add_out1 != 19'sb0000000000000000000 ? 1'b1 :1'b0); 
  assign y = Compare_To_Zero2_out1; 
 endmodule