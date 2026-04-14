module top_module(in1,in2,sl,out);input[4:0] in1;
  input[4:0] in2;  
  input sl;   
  output[4:0] out;
  
  assign out=(sl==0)?in1:in2;
  
endmodule