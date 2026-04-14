module top_module(input [31:0] ina,input [31:0] inb,
                input sel,
                output [31:0] out);assign out = sel ? inb : ina;

endmodule