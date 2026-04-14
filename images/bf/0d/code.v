module top_module( 
  IN0, 
  IN1,
  SUM, 
  COUT 
);input IN0, IN1;
  output SUM, COUT;

  assign SUM  = IN0^IN1;
  assign COUT = IN0&IN1;

endmodule