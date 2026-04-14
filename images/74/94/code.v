module top_module(sel, a, b, c, y);parameter bitwidth=32;
input [1:0] sel;
input [bitwidth-1:0] a, b, c;
output [bitwidth-1:0] y;
reg [bitwidth-1:0] y;

always @(sel or a or b or c)
begin
case (sel)
2'b00 : y = a;
2'b01 : y = b;
2'b10 : y = c;
endcase
end
endmodule