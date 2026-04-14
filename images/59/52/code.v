module top_module(
 input 	       clk,
 input 	       rst,
 input [15:0]  arg_0,
 input [15:0]  arg_1,
 input 	       arg_2,
 output [15:0] ret_0,
 output [15:0] ret_1,
 output        ret_2,
 output        ret_3);wire [15:0] x;
   wire [15:0] y;
   wire        is_sub;
   wire        ys;
   wire        yys;
   wire [15:0] yy;
   wire        diff_sign;
   wire [7:0]  xe;
   wire [7:0]  ye;
   wire        swap;
   wire        neg_lhs;
   wire        neg_rhs;
   wire [15:0] lhs;
   wire [15:0] rhs;


   assign x = arg_0;
   assign y = arg_1;
   assign is_sub = arg_2;
   assign ys = y[15];
   assign yys = is_sub ? ~ys : ys;
   assign yy = {yys, y[14:0]};
   assign xe = x[14:7];
   assign ye = y[14:7];

   assign diff_sign = x[15] ^ yy[15];

   assign swap = xe < ye;
   assign lhs = swap ? yy : x;
   assign rhs = swap ? x : yy;

   assign neg_lhs = diff_sign ? lhs[15] : 0;
   assign neg_rhs = diff_sign ? rhs[15] : 0;

   assign ret_0 = lhs;
   assign ret_1 = rhs;
   assign ret_2 = neg_lhs;
   assign ret_3 = neg_rhs;

endmodule