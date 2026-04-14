module top_module(
  input D, C, E, R,
  output Q
);wire Q_not;
  
  assign Q_not = ~Q;
  
  assign Q = (E == 1'b1) ? 1'b1 :
             (R == 1'b1) ? 1'b0 :
             (C == 1'b1) ? D :
                           Q_not;

endmodule