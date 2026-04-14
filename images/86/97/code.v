module top_module(input [3:0] in, input [1:0] sel, output reg out);wire [1:0] s1, s2;
   wire [1:0] not_sel;

   // invert select signals
   assign not_sel = ~sel;

   // connect inputs to 2-to-1 muxes
   assign s1[0] = in[0];
   assign s1[1] = in[1];
   assign s2[0] = in[2];
   assign s2[1] = in[3];

   // connect select signals to 2-to-1 muxes
   assign out = (not_sel[1] & s1[sel[0]]) | (sel[1] & s2[not_sel[0]]);

endmodule