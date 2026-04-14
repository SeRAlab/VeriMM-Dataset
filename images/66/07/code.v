module top_module(
  input a,
  input b,
  input c,
  input d,
  output y
);// Voltage supply signals
  supply1 VPWR;
  supply0 VGND;
  supply1 VPB;
  supply0 VNB;

  wire ab;
  wire cd;
  wire abcd;

  // Instantiate a 2-input NOR gate
  assign ab = ~(a | b);
  assign cd = ~(c | d);
  assign abcd = ~(ab | cd);

  // Final output as NOR of abcd
  assign y = ~abcd;

endmodule