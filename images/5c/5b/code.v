module top_module(input [31:0] ina, inb,
              input sel,
              output [31:0] out);assign out=(sel==1'b0) ? ina : inb;

endmodule