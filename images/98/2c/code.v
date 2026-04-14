module top_module(

input wire [1:0] sel,
input wire [2:0] i0,
input wire [2:0] i1,
input wire [2:0] i2,
input wire [2:0] i3,
input wire [2:0] i4,
output reg [2:0] o

);always @* begin
  case (sel)
    0 : o = i0;
    1 : o = i1;
    2 : o = i2;
    3 : o = i3;
    2 : o = i4;
  endcase
end

endmodule