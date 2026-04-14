module mux4to1
(
  input [1:0] sel,
  input in0,
  input in1,
  input in2,
  input in3,
  output out
);

assign out = (sel == 2'b00) ? in0 :
             (sel == 2'b01) ? in1 :
             (sel == 2'b10) ? in2 :
             (sel == 2'b11) ? in3 : 1'b0;

endmodule