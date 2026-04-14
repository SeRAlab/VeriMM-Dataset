module mux_2_1(input [1:0] in, input sel, output out);
  assign out = (sel == 1'b0) ? in[0] : in[1];
endmodule