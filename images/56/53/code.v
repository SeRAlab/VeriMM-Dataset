module top_module(out, sel, in0, in1);output reg [31:0] out;
input [31:0] in0, in1;
input sel;

always@ (sel or in0 or in1)
begin 
case(sel)
0:out <= in0;
1:out <=in1;
endcase
end
endmodule