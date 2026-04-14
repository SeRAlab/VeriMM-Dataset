module top_module(y,in1,in2,s);output y;
input in1,in2;
input s;
assign y=s?in1:in2;
endmodule