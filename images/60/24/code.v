module top_module(
           sin_coefficient,
           cos_coefficient,
           alpha_current,
           beta_current,
           direct_current,
           quadrature_current
          );input   signed [17:0] sin_coefficient;  
  input   signed [17:0] cos_coefficient;  
  input   signed [17:0] alpha_current;  
  input   signed [17:0] beta_current;  
  output  signed [17:0] direct_current;  
  output  signed [17:0] quadrature_current;  


  wire signed [35:0] Product2_out1;  
  wire signed [35:0] Product3_out1;  
  wire signed [35:0] Add1_out1;  
  wire signed [17:0] D_Data_Type_out1;  
  wire signed [35:0] Product1_out1;  
  wire signed [35:0] Product_out1;  
  wire signed [35:0] Add_out1;  
  wire signed [17:0] Q_Data_Type_out1;  

  
  
  


  
  assign Product2_out1 = alpha_current * cos_coefficient;



  
  assign Product3_out1 = beta_current * sin_coefficient;



  
  assign Add1_out1 = Product2_out1 + Product3_out1;



  
  assign D_Data_Type_out1 = ((Add1_out1[35] == 1'b0) && (Add1_out1[34:31] != 4'b0000) ? 18'sb011111111111111111 :
              ((Add1_out1[35] == 1'b1) && (Add1_out1[34:31] != 4'b1111) ? 18'sb100000000000000000 :
              $signed(Add1_out1[31:14])));



  assign direct_current = D_Data_Type_out1;

  
  assign Product1_out1 = beta_current * cos_coefficient;



  
  assign Product_out1 = alpha_current * sin_coefficient;



  
  assign Add_out1 = Product1_out1 - Product_out1;



  
  assign Q_Data_Type_out1 = ((Add_out1[35] == 1'b0) && (Add_out1[34:31] != 4'b0000) ? 18'sb011111111111111111 :
              ((Add_out1[35] == 1'b1) && (Add_out1[34:31] != 4'b1111) ? 18'sb100000000000000000 :
              $signed(Add_out1[31:14])));



  assign quadrature_current = Q_Data_Type_out1;

endmodule