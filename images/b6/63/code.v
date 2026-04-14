module top_module(
 input        clk,
 input        rst,
 input        arg_0,
 input        arg_1,
 input [20:0] arg_2,
 input [20:0] arg_3,
 input [4:0]  arg_4,
 input        arg_5,
 input        arg_6,
 output [21:0] ret_0,
 output        ret_1,
 output        ret_2,
 output [4:0]  ret_3,
 output        ret_4,
 output        ret_5);reg         xn;
   reg         yn;
   wire [21:0] rxy;
   wire        diff_sign;
   wire [21:0] r_final;
   
   always @(posedge clk) begin
      if (rst) begin
         xn <= 0;
         yn <= 0;
      end else begin
         xn <= arg_5;
         yn <= arg_6;
      end
   end

   assign diff_sign = (xn != yn);

   assign rxy = arg_2 + arg_3;
   assign r_final = diff_sign ? (rxy + 1) : rxy;

   assign ret_0 = r_final;
   assign ret_1 = arg_0;
   assign ret_2 = arg_1;
   assign ret_3 = arg_4;
   assign ret_4 = arg_5;
   assign ret_5 = arg_6;
   
endmodule