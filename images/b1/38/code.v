module top_module(output O,output CO,input I0,input I1,input CI);parameter I0_POLARITY = 1; 
  parameter I1_POLARITY = 1; 
  wire i0; 
  wire i1; 
  assign i0 = I0_POLARITY ? I0 : ~I0; 
  assign i1 = I1_POLARITY ? I1 : ~I1; 
  assign {CO, O} = i0 + i1 + CI; 
 endmodule