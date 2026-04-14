module top_module( R, S, Q, Qbar );input R, S;
  output Q, Qbar;

  assign Q = !(R || Qbar);
  assign Qbar = !(S || Q);

endmodule