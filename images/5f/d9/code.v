module top_module(
    input [3:0] a,
    input [3:0] b,
    input carry_in,
    output [3:0] sum,
    output carry_out
);assign {carry_out, sum} = {1'd0, a} + {1'd0, b} + {4'd0, carry_in};
    
endmodule