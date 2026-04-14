module top_module(I, O0, O1, O2, O3, sel);input [11:0] I;
  output [11:0] O0, O1, O2, O3;
  input [1:0] sel;

  assign O0 = (sel == 2'b00) ? I : 12'b0;
  assign O1 = (sel == 2'b01) ? I : 12'b0;
  assign O2 = (sel == 2'b10) ? I : 12'b0;
  assign O3 = (sel == 2'b11) ? I : 12'b0;

endmodule