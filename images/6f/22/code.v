module top_module(S, D, C);// I/O port declaration
input [31:0] D;
input C;
output [31:0] S;

//internal nets
wire C1;
wire [30:0] shifted;

//Instantiate logic gate primitives
not not1(C1,C);
assign shifted = {D[29:0], 1'b0};

assign S = (C1 == 1'b1) ? shifted : D;

endmodule