module top_module(
                        input  [31:0] A,
                        input  [31:0] B,
                        input   select,
                        output [31:0] ArithOut);assign ArithOut = (select == 1'b1)? A : B;endmodule