module top_module(CLK_IN,reset,enb,In1,Out1);input CLK_IN; 
  input reset; 
  input enb; 
  input In1; 
  output Out1; 
  reg Unit_Delay_out1; 
  wire Unit_Delay_out1_1; 
  wire In1_1; 
  always @(posedge CLK_IN) 
  begin : Unit_Delay_process 
  if (reset == 1'b1) begin 
  Unit_Delay_out1 <= 1'b0; 
  end 
  else if (enb) begin 
  Unit_Delay_out1 <= In1; 
  end 
  end 
  assign Unit_Delay_out1_1 = ~ Unit_Delay_out1; 
  assign In1_1 = In1 & Unit_Delay_out1_1; 
  assign Out1 = In1_1; 
 endmodule