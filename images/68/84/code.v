module top_module(out, vout, in, vin);output out, vout;
input in;
input [3:0] vin;
assign out = !in;
assign vout = !vin;
endmodule