module top_module(a,b,c,d,Control,S);input [31:0] a,b,c,d;
output reg [31:0] S;
input [1:0] Control;

always@(a,b,c,d,Control)
  case(Control)
    2'b00: S = a;
    2'b01: S = b;
    2'b10: S = c;
    2'b11: S = d;
  endcase
endmodule