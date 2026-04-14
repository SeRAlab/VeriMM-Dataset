module top_module(Phase_Voltages_0,Phase_Voltages_1,Phase_Voltages_2);output signed [19:0] Phase_Voltages_0; 
  output signed [19:0] Phase_Voltages_1; 
  output signed [19:0] Phase_Voltages_2; 
  wire signed [19:0] Constant_out1 [0:2]; 
  assign Constant_out1[0] = 20'sb00000000000000000000; 
  assign Constant_out1[1] = 20'sb00000000000000000000; 
  assign Constant_out1[2] = 20'sb00000000000000000000; 
  assign Phase_Voltages_0 = Constant_out1[0]; 
  assign Phase_Voltages_1 = Constant_out1[1]; 
  assign Phase_Voltages_2 = Constant_out1[2]; 
 endmodule