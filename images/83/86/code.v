module top_module(
clk,
hex,
symbol
);input clk;
input [3:0] hex;

output [6:0] symbol;

reg [6:0] symbol;

always @(posedge clk)
case (hex)
4'h1 : symbol <= 7'b1001111;
4'h2 : symbol <= 7'b0010010;
4'h3 : symbol <= 7'b0000110;
4'h4 : symbol <= 7'b1001100;
4'h5 : symbol <= 7'b0100100;
4'h6 : symbol <= 7'b0100000;
4'h7 : symbol <= 7'b0001111;
4'h8 : symbol <= 7'b0000000;
4'h9 : symbol <= 7'b0000100;
4'hA : symbol <= 7'b0001000;
4'hB : symbol <= 7'b1100000;
4'hC : symbol <= 7'b0110001;
4'hD : symbol <= 7'b1000010;
4'hE : symbol <= 7'b0110000;
4'hF : symbol <= 7'b0111000;
default: symbol <= 7'b0000001;
endcase
endmodule