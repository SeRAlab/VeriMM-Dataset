module top_module(i_0r, i_0a, o_0r, o_0a, reset);input i_0r;
  output i_0a;
  output o_0r;
  input o_0a;
  input reset;

  wire nreset_0;
  wire firsthsa_0;
  wire nfirsthsa_0;
  wire firsthsd_0;
  wire noa_0;

  // Inverter module
  assign nreset_0 = ~reset;
  assign nfirsthsa_0 = ~firsthsa_0;
  assign noa_0 = ~o_0a;

  // AO22 equivalent (using gate-level modeling in Verilog)
  assign o_0r = (nreset_0 & nfirsthsa_0) | (i_0r & firsthsd_0);
  assign firsthsa_0 = (nreset_0 & o_0a) | (nreset_0 & firsthsa_0);
  assign firsthsd_0 = (firsthsa_0 & noa_0) | (firsthsa_0 & firsthsd_0);
  
  // AND gate equivalent
  assign i_0a = o_0a & firsthsd_0;

endmodule