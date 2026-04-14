module top_module(i, o);input  [3:0] i;
output [3:0] o;

wire logic [3:0] i;
reg        [3:0] o;

always @* o = i;

endmodule