module top_module(a,b,add);input signed [3:0]a,b;
output signed[7:0]add;
assign add=a+b;
endmodule