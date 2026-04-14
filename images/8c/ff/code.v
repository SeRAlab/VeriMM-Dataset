module top_module(i, o);input  logic [3:0] i;
output logic [3:0] o;

always @* o = i;

endmodule