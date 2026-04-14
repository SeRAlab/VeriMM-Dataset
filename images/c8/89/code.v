module concatenation_module (
 input [15:0] in_signal,
 output [5:0] out_signal1,
 output [9:0] out_signal2
);

 assign out_signal1 = {in_signal[15:10], in_signal[1:0]};
 assign out_signal2 = in_signal[9:0];

endmodule