module top_module(bin, gray);input [7:0] bin;
output [7:0] gray;
assign gray = bin[7:0] ^ {1'b0, bin[7:1]};
endmodule