module top_module(
 input 	       clk,
 input 	       rst,
 input [21:0]  arg_0,
 input 	       arg_1,
 input 	       arg_2,
 input [4:0]   arg_3,
 input 	       arg_4,
 input 	       arg_5,
 output [20:0] ret_0,
 output        ret_1,
 output        ret_2,
 output [4:0]  ret_3,
 output        ret_4,
 output        ret_5,
 output        ret_6);wire [21:0] r;
   wire        xs;
   wire        ys;
   wire [4:0]  e;
   wire        xn;
   wire        yn;
   wire        diff_sign;
   wire        with_carry;
   wire        neg;
   wire [20:0] neg_r;
   wire [20:0] half_r;
   wire [20:0] r_diff;
   wire [20:0] r_same;
   wire [20:0] r_final;
   wire [4:0]  eplus;
   wire [4:0]  e_final;
   
   
   assign r = arg_0;
   assign xs = arg_1;
   assign ys = arg_2;
   assign e = arg_3;
   assign xn = arg_4;
   assign yn = arg_5;
   assign diff_sign = (xn != yn);
   assign with_carry = r[21:21];
   assign neg_r = (~r) + 1;
   assign half_r = r[21:1];
   assign neg = diff_sign & !with_carry;
   assign eplus = e + 1;

   assign r_diff = with_carry ? r[20:0] : neg_r;
   assign r_same = with_carry ? half_r : r[20:0];
   assign r_final = diff_sign ? r_diff : r_same;
   assign e_final = (!diff_sign && with_carry) ? eplus : e;

   assign ret_0 = r_final;
   assign ret_1 = xs;
   assign ret_2 = ys;
   assign ret_3 = e_final;
   assign ret_4 = neg;
   assign ret_5 = xn;
   assign ret_6 = yn;
   
endmodule