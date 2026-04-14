module top_module(d,en,q);input en;
input [4:0] d;
output [31:0] q;
assign q[4:0]= (en) ? d : 0;
assign q [31:05] = 0;

endmodule