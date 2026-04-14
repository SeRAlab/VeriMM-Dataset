module top_module(input [1:0] a,
               input [1:0] b,

               output [1:0] f_and,
               output [1:0] f_xor);assign f_and = a & b;
    assign f_xor = a ^ b;

endmodule