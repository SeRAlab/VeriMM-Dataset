module mux_4to1 (
  input [3:0] a,
  input [1:0] sel,
  output y
);

  assign y = (sel == 2'b00) ? a[0] :
             (sel == 2'b01) ? a[1] :
             (sel == 2'b10) ? a[2] :
                              a[3];

endmodule