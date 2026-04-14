module top_module(count,trig,out);output out;
input [15:0] trig, count;

assign out = (count<trig);endmodule