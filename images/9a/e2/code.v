module top_module(a,b,out,sel);input [3:0]a;
input [3:0]b;
output reg [3:0]out;
input sel;
always @ *
begin
case (sel)
1'b0: begin out=a; end
1'b1: begin out=b; end
endcase
end
endmodule