module top_module(outp, outm, outl, in);output outp, outm, outl; 
  input in; 
  assign #1 outp = ~in; 
  assign #1 outm = in ? in : 1'b0; 
  assign #1 outl = in === 1'b1; 
 endmodule