module top_module( clk,rst,st);input clk,rst;
output [1:0] st;

reg [1:0] st,next_st;

always @(posedge clk or posedge rst)
  if (rst)
     st <= 2'b0;
  else
     st <= next_st;

always @(st)
     case (st)
       2'b00: next_st <= 2'b01;
       2'b01: next_st <= 2'b11;
       2'b11: next_st <= 2'b10;
       2'b10: next_st <= 2'b00;
     endcase

endmodule