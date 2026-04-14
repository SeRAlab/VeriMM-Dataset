module top_module(i_0r, i_0a, o_0r, o_0a, reset);input i_0r;
  output i_0a;
  output o_0r;
  input o_0a;
  input reset;
  wire b_0;
  wire tech1_oint;

  // Assuming AO222EHD is a 2-input AND gate, we can replace it with a standard AND gate
  and I0 (o_0r, i_0r, b_0);

  // Assuming AN2B1CHD is a 2-input AND gate with reset functionality
  and I1 (tech1_oint, o_0r, reset);

  // Assuming INVHHD is an inverter
  not I2 (b_0, i_0a);

  // Assuming BUFEHD is a buffer
  buf I3 (i_0a, o_0r);
endmodule