module top_module( select, d, q );input select;
input[1:0] d;
output     q;

wire      q;
wire      select;
wire[1:0] d;

assign q = d[select];

endmodule