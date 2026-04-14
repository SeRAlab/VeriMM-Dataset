module top_module(
           phase_currents_0,
           phase_currents_1,
           alpha_current,
           beta_current
          );input   signed [17:0] phase_currents_0;  
  input   signed [17:0] phase_currents_1;  
  output  signed [17:0] alpha_current;  
  output  signed [17:0] beta_current;  


  wire signed [17:0] Alpha_Current_Data_Type_out1;  
  wire signed [35:0] Alpha_Gain_With_Headrom_out1;  
  wire signed [35:0] Beta_Gain_With_Headrom_out1;  
  wire signed [35:0] Add_out1;  
  wire signed [17:0] Beta_Current_Data_Type_out1;  

  
  
  
  
  


  
  
  
  
  
  assign Alpha_Current_Data_Type_out1 = {{2{phase_currents_0[17]}}, phase_currents_0[17:2]};



  assign alpha_current = Alpha_Current_Data_Type_out1;

  
  assign Alpha_Gain_With_Headrom_out1 = 37837 * phase_currents_0;



  
  assign Beta_Gain_With_Headrom_out1 = 75674 * phase_currents_1;



  
  assign Add_out1 = Alpha_Gain_With_Headrom_out1 + Beta_Gain_With_Headrom_out1;



  
  assign Beta_Current_Data_Type_out1 = Add_out1[35:18];



  assign beta_current = Beta_Current_Data_Type_out1;

endmodule