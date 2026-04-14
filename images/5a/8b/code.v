module top_module(input [(1 - 1):0] sel,input [(1 - 1):0] d0,input [(1 - 1):0] d1,output [(1 - 1):0] y,input clk,input ce,input clr);wire sel_1_20; 
  wire [(1 - 1):0] d0_1_24; 
  wire [(1 - 1):0] d1_1_27; 
  wire [(1 - 1):0] sel_internal_2_1_convert; 
  reg [(1 - 1):0] unregy_join_6_1; 
  assign sel_1_20 = sel; 
  assign d0_1_24 = d0; 
  assign d1_1_27 = d1; 
  assign sel_internal_2_1_convert = {sel_1_20}; 
  always @(d0_1_24 or d1_1_27 or sel_internal_2_1_convert) 
  begin:proc_switch_6_1 
  case (sel_internal_2_1_convert) 
  1'b0 : 
  begin 
  unregy_join_6_1 = d0_1_24; 
  end 
  default: 
  begin 
  unregy_join_6_1 = d1_1_27; 
  end 
  endcase 
  end 
  assign y = unregy_join_6_1; 
 endmodule