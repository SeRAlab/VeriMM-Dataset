module top_module(ain,bin,cin,din,select,out);input [15:0]ain,bin,cin,din;
 input [3:0]select;
 output [15:0] out;
 assign out=({16{select[0]}}&ain)|
({16{select[1]}}&bin)|
({16{select[2]}}&cin)|
({16{select[3]}}&din);endmodule