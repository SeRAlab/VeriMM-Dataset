module top_module(input [7:0] narrow, input [63:0] quad, output [31:0] longout, output [63:0] quadout);`ifdef verilator
   assign longout = $c32("(",narrow,"+1)");
   assign quadout = $c64("(",quad,"+1)");
`else
   assign longout = narrow + 8'd1;
   assign quadout = quad + 64'd1;
`endif
endmodule