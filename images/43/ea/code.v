module mux_4_to_1 (
  input [1:0] sel,
  input d0,
  input d1,
  input d2,
  input d3,
  output y
);

  assign y = (sel == 2'b00) ? d0 :
             (sel == 2'b01) ? d1 :
             (sel == 2'b10) ? d2 :
             d3;

endmodule