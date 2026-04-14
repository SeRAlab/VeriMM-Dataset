module top_module(
           in_select,
           in1,
           in2,
           in3,
           A,
           B
          );input   [1:0] in_select;
  input   in1;
  input   in2;
  input   in3;
  output  A;
  output  B;


  wire Switch_out1;
  wire Switch1_out1;
  wire Switch2_out1;
  wire Switch3_out1;
  wire Xor_out1;


  // <S8>/Switch
  assign Switch_out1 = (in_select == 2'b00 ? in3 :
                        in_select == 2'b01 ? in2 :
                        in_select == 2'b10 ? in1 :
                        in_select == 2'b11 ? Xor_out1 :
                        1'b0);



  assign A = Switch_out1;

  // <S8>/Switch1
  assign Switch1_out1 = (in_select == 2'b00 ? in2 :
                         in_select == 2'b01 ? Xor_out1 :
                         in_select == 2'b10 ? in3 :
                         in_select == 2'b11 ? in1 :
                         1'b0);



  assign B = Switch1_out1;

  // <S8>/Switch2
  assign Switch2_out1 = (in_select == 2'b00 ? in1 :
                         in_select == 2'b01 ? in3 :
                         in_select == 2'b10 ? Xor_out1 :
                         in_select == 2'b11 ? in2 :
                         1'b0);

  // <S8>/Switch3
  assign Switch3_out1 = (in_select == 2'b00 ? Xor_out1 :
                         in_select == 2'b01 ? in1 :
                         in_select == 2'b10 ? in2 :
                         in_select == 2'b11 ? in3 :
                         1'b0);

  // <S8>/XOR
  assign Xor_out1 = in1 ^ in2;

endmodule