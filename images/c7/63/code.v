module mux2to1
   (ctrl,
    D0,
    D1,
    S);
  input ctrl;
  input D0;
  input D1;
  output S;

  assign S = (ctrl == 0) ? D0 : D1;
endmodule