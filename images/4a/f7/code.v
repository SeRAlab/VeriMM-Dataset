module top_module(output Q, input C, R, E, D);// Define a D flip-flop with asynchronous reset
  reg Q_temp;
  always @(posedge C, posedge R)
    if (R)
      Q_temp <= 1'b0;
    else if (E)
      Q_temp <= D;

  // Output the value of the flip-flop
  assign Q = Q_temp;

endmodule