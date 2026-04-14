module top_module(x,y,A,B,C,D);input A,B,C,D;
output x,y;
assign x = A | (B & C) | (~B & C);
assign y = (~B & C) | (B & ~C & ~D);
endmodule