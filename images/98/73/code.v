module top_module(
           in0,
           in1,
           in2,
           out0
          );input   signed [17:0] in0;  
  input   signed [17:0] in1;  
  input   signed [17:0] in2;  
  output  signed [17:0] out0;  


  wire signed [17:0] MinMax1_muxout [0:2];  
  wire signed [17:0] MinMax1_stage1_val [0:1];  
  wire signed [17:0] MinMax1_stage2_val;  


  assign MinMax1_muxout[0] = in0;
  assign MinMax1_muxout[1] = in1;
  assign MinMax1_muxout[2] = in2;

  
  
  assign MinMax1_stage1_val[0] = (MinMax1_muxout[0] >= MinMax1_muxout[1] ? MinMax1_muxout[0] :
              MinMax1_muxout[1]);
  assign MinMax1_stage1_val[1] = MinMax1_muxout[2];



  
  assign MinMax1_stage2_val = (MinMax1_stage1_val[0] >= MinMax1_stage1_val[1] ? MinMax1_stage1_val[0] :
              MinMax1_stage1_val[1]);



  assign out0 = MinMax1_stage2_val;

endmodule