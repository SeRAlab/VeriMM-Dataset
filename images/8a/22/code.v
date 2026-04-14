module top_module(data,result);parameter lpm_width = 1; 
  parameter lpm_size = 1; 
  parameter lpm_type = "lpm_or"; 
  parameter lpm_hint = "UNUSED"; 
  input [(lpm_size * lpm_width)-1:0] data; 
  output [lpm_width-1:0] result; 
  reg [lpm_width-1:0] result_tmp; 
  integer i; 
  integer j; 
  integer k; 
  initial 
  begin 
  if (lpm_width <= 0) 
  begin 
  $display("Value of lpm_width parameter must be greater than 0 (ERROR)"); 
  $display("Time: %0t Instance: %m", $time); 
  $finish; 
  end 
  if (lpm_size <= 0) 
  begin 
  $display("Value of lpm_size parameter must be greater than 0 (ERROR)"); 
  $display("Time: %0t Instance: %m", $time); 
  $finish; 
  end 
  end 
  always @(data) 
  begin 
  for (i=0; i<lpm_width; i=i+1) 
  begin 
  result_tmp[i] = 1'b0; 
  for (j=0; j<lpm_size; j=j+1) 
  begin 
  k = (j * lpm_width) + i; 
  result_tmp[i] = result_tmp[i] | data[k]; 
  end 
  end 
  end 
  assign result = result_tmp; 
 endmodule