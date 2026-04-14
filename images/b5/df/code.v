module top_module(distance,data,direction,result);parameter lpm_type = "LPM_CLSHIFT"; 
  parameter lpm_shifttype = "ARITHMETIC"; 
  parameter lpm_width = 32; 
  parameter lpm_widthdist = 5; 
  input wire [lpm_widthdist-1:0] distance; 
  input wire [lpm_width-1 :0] data; 
  input wire direction; 
  output wire [lpm_width-1 :0] result; 
  assign result = direction ? data >>> distance : data << distance; 
 endmodule