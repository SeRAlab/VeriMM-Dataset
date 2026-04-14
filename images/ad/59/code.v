module top_module(
  output source,
  output sink
);parameter Is = 10; // value of current source in mA
parameter Ic = 5; // value of current sink in mA

assign source = Is * 0.001; // convert mA to A and assign to source output
assign sink = -Ic * 0.001; // convert mA to A and assign to sink output

endmodule