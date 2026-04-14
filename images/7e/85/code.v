module top_module(IN0,IN1,CIN,COUT,SUM);input IN0, IN1, CIN; 
  output COUT, SUM; 
  assign SUM = IN0^IN1^CIN; 
  assign COUT = ((CIN&IN0)|(CIN&IN1)|(IN0&IN1)); 
 endmodule