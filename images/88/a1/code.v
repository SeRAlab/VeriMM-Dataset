module top_module(clk, probe0, probe1, probe2, probe3, probe4, probe5, probe6, probe7, output_signal);input clk;
  input [63:0] probe0;
  input [63:0] probe1;
  input [31:0] probe2;
  input [31:0] probe3;
  input [0:0] probe4;
  input [0:0] probe5;
  input [0:0] probe6;
  input [0:0] probe7;
  output [127:0] output_signal;
  
  assign output_signal = {probe0, probe1, probe2, probe3, probe4, probe5, probe6, probe7};
endmodule