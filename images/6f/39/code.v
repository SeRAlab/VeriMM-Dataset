module top_module(input wire x, input wire y, output reg z);always @*
     z <= x ~& y;
endmodule