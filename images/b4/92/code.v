module top_module(output wire y, input wire a, b);specify
    specparam ta = 1;
    specparam tb = 2;
  endspecify
  
  
  
  
  assign #(ta+tb) y = a & b;
endmodule