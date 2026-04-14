module top_module(a,b,y);input a,b;
output y;
assign y = !(a||b);
endmodule