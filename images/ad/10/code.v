module mux_4to1 (
  input A,
  input B,
  input C,
  input D,
  input [1:0] sel,
  output Y
);

  assign Y = (sel == 2'b00) ? A :
             (sel == 2'b01) ? B :
             (sel == 2'b10) ? C : D;

endmodule