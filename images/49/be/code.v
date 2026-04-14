module top_module(input signed [3:0] a, output [3:0] y);assign y = a[3] ? -a : a;
endmodule