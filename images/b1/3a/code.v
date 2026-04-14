module top_module(input  wire [15:0] i_dividend,
                            input  wire [15:0] i_divisor,
                            input  wire [15:0] i_remainder,
                            input  wire [15:0] i_quotient, 
                            output wire [15:0] o_dividend,
                            output wire [15:0] o_remainder,
                            output wire [15:0] o_quotient);wire [15:0] new_remainder = {i_remainder[14:0], i_dividend[15]};
   wire [15:0] if_quotient = {i_quotient[14:0], 1'd0};
   wire [15:0] else_quotient = {i_quotient[14:0], 1'd1};
   wire [15:0] else_remainder = new_remainder - i_divisor;
   
   assign o_quotient = (new_remainder < i_divisor) ? if_quotient : else_quotient;
   assign o_remainder = (new_remainder < i_divisor) ? new_remainder : else_remainder;
   assign o_dividend = {i_dividend[14:0], 1'd0};endmodule