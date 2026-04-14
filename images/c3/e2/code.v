module high_low
  (
   input  logic [3:0] in_signal,
   output logic [1:0] out_signal
   );

   always_comb out_signal[1] = in_signal[3];
   always_comb out_signal[0] = in_signal[0];

endmodule