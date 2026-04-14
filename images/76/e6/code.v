module top_module( cin , b , s, cout);input [63:0]cin,b;
output [63:0] cout,s;

assign s = 64'd4 ^ b ^cin ;
assign cout =(64'd4 & b)|(64'd4 & cin)|(b &cin);
endmodule