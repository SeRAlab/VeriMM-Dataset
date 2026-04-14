module top_module( clk,rst,st);input clk,rst;
output [1:0] st;

reg [1:0] st;

always @(posedge clk or posedge rst)
  if (rst)
     st <= 2'b0;
  else
     case (st)
       2'b00: st <= 2'b01;
       2'b01: st <= 2'b11;
       2'b11: st <= 2'b10;
       2'b10: st <= 2'b00;
     endcase
endmodule