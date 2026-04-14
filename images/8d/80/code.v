module top_module(
           in_select,
           in1,
           in2,
           A,
           B
          );input   in_select;
  input   in1;
  input   in2;
  output  A;
  output  B;


  wire Switch_out1;
  wire Switch1_out1;


  
  assign Switch_out1 = (in_select == 1'b0 ? in2 :
              in1);



  assign A = Switch_out1;

  
  assign Switch1_out1 = (in_select == 1'b0 ? in1 :
              in2);



  assign B = Switch1_out1;

endmodule