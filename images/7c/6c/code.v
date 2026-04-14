module top_module(sum,c_out,a1,b1);output[29:0] sum;
output c_out;
input[29:0] a1,b1;
assign{c_out,sum}=a1+b1;
endmodule