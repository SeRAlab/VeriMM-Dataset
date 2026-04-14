module top_module(in, out, vdd18);input vdd18;
  input [7:0] in;
  output [7:0] out;

  assign out = vdd18 ? in : 8'b0;
endmodule