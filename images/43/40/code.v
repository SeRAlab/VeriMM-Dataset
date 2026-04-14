module top_module(vd, vz);parameter integer rscid = 0; 
  parameter ready = 0; 
  parameter valid = 1; 
  output vd; 
  input vz; 
  wire vd; 
  assign vd = vz; 
 endmodule