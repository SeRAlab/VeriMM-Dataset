module mux_4to1 (
  input [3:0] d,
  input [1:0] sel,
  output y
);

  assign y = (sel == 2'b00) ? d[0] :
             (sel == 2'b01) ? d[1] :
             (sel == 2'b10) ? d[2] : d[3];

endmodule