module top_module(input clk, input key, input nrq1, input nrq2, input nrq3, output [1:0] mux);reg [1:0] count; 
  always @(posedge clk) 
  begin 
  if (count == 0) 
  begin 
  count <= key ? 1 : 0; 
  end 
  else if ((count == 1 && nrq1) || (count == 2 && nrq2)) 
  begin 
  count <= key ? 2 : 3; 
  end 
  else if (count == 3 && nrq3) 
  begin 
  count <= key ? 1 : 0; 
  end 
  end 
  assign mux = count; 
 endmodule