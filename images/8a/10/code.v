module top_module(addout,ain,bin);input [15:0] ain,bin;
output [15:0] addout;
assign addout = ain+bin;endmodule