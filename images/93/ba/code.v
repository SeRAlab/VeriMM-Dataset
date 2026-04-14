module top_module(input [31:0]A,B,output [31:0]p,g);assign p=A^B;
assign g=A&B;
endmodule