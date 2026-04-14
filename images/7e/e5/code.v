module top_module(output Y,input A,input B,input C,input D);parameter [15:0] INIT = 16'h0; 
  assign Y = INIT >> {D, C, B, A}; 
 endmodule