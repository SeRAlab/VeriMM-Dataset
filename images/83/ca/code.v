module top_module(
    a,b,g,p
);input a;
input b;
output g;
output p;

assign g = a & b;
assign p = a ^ b;

endmodule