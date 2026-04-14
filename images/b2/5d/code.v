module top_module(in0,
           in1,
           out0);input   signed [12:0] in0;  
  input   signed [12:0] in1;  
  output  signed [12:0] out0;  


  wire signed [12:0] Deno_muxout [0:1];  
  wire signed [12:0] Deno_stage1_val;  


  assign Deno_muxout[0] = in0;
  assign Deno_muxout[1] = in1;

  
  
  assign Deno_stage1_val = (Deno_muxout[0] >= Deno_muxout[1] ? Deno_muxout[0] :
              Deno_muxout[1]);



  assign out0 = Deno_stage1_val;

endmodule