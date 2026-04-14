module top_module(
           adc_0,
           adc_1,
           phase_currents_0,
           phase_currents_1
          );input   signed [17:0] adc_0;  
  input   signed [17:0] adc_1;  
  output  signed [17:0] phase_currents_0;  
  output  signed [17:0] phase_currents_1;  


  wire signed [17:0] adc [0:1];  
  wire signed [17:0] ADC_Zero_Offset_out1;  
  wire signed [19:0] Add_v;  
  wire signed [19:0] Add_sub_cast;  
  wire signed [19:0] Add_sub_cast_1;  
  wire signed [19:0] Add_out1 [0:1];  
  wire signed [17:0] ADC_Amps_Per_Driver_Unit_out1;  
  wire signed [37:0] Product_mul_temp;  
  wire signed [37:0] Product_mul_temp_1;  
  wire signed [17:0] phase_currents [0:1];  


  assign adc[0] = adc_0;
  assign adc[1] = adc_1;

  
  assign ADC_Zero_Offset_out1 = 18'sb000000000000000000;



  
  assign Add_v = {ADC_Zero_Offset_out1[17], {ADC_Zero_Offset_out1, 1'b0}};
  assign Add_sub_cast = adc[0];
  assign Add_out1[0] = Add_sub_cast - Add_v;
  assign Add_sub_cast_1 = adc[1];
  assign Add_out1[1] = Add_sub_cast_1 - Add_v;



  
  assign ADC_Amps_Per_Driver_Unit_out1 = 18'sb010100000000000000;



  
  assign Product_mul_temp = Add_out1[0] * ADC_Amps_Per_Driver_Unit_out1;
  assign phase_currents[0] = ((Product_mul_temp[37] == 1'b0) && (Product_mul_temp[36:34] != 3'b000) ? 18'sb011111111111111111 :
              ((Product_mul_temp[37] == 1'b1) && (Product_mul_temp[36:34] != 3'b111) ? 18'sb100000000000000000 :
              $signed(Product_mul_temp[34:17])));
  assign Product_mul_temp_1 = Add_out1[1] * ADC_Amps_Per_Driver_Unit_out1;
  assign phase_currents[1] = ((Product_mul_temp_1[37] == 1'b0) && (Product_mul_temp_1[36:34] != 3'b000) ? 18'sb011111111111111111 :
              ((Product_mul_temp_1[37] == 1'b1) && (Product_mul_temp_1[36:34] != 3'b111) ? 18'sb100000000000000000 :
              $signed(Product_mul_temp_1[34:17])));



  assign phase_currents_0 = phase_currents[0];

  assign phase_currents_1 = phase_currents[1];

endmodule