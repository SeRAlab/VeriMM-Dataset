module top_module(
           In1_0,
           In1_1,
           In1_2,
           Out1_0,
           Out1_1,
           Out1_2
          );input   signed [17:0] In1_0;  
  input   signed [17:0] In1_1;  
  input   signed [17:0] In1_2;  
  output  signed [17:0] Out1_0;  
  output  signed [17:0] Out1_1;  
  output  signed [17:0] Out1_2;  


  wire signed [17:0] In1 [0:2];  
  wire signed [17:0] Data_Type_Conversion_out1 [0:2];  


  assign In1[0] = In1_0;
  assign In1[1] = In1_1;
  assign In1[2] = In1_2;

  
  assign Data_Type_Conversion_out1[0] = {In1[0][17], In1[0][17:1]};
  assign Data_Type_Conversion_out1[1] = {In1[1][17], In1[1][17:1]};
  assign Data_Type_Conversion_out1[2] = {In1[2][17], In1[2][17:1]};



  assign Out1_0 = Data_Type_Conversion_out1[0];

  assign Out1_1 = Data_Type_Conversion_out1[1];

  assign Out1_2 = Data_Type_Conversion_out1[2];

endmodule