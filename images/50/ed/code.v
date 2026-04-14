module top_module(a,b,ALUControl,result,zero);parameter n = 63;
 input [n:0]a;
 input [n:0]b;
 input [3:0]ALUControl;
 output reg [n:0] result;
 output zero;
 always @(*)
  begin
   case(ALUControl)
   4'b0000: result = a & b;
   4'b0001: result = a | b;
   4'b0010: result = a + b;
   4'b0110: result = a - b;
   default: result = a + b;
   endcase
  end
 assign zero = (result==64'd0) ? 1'b1: 1'b0;
endmodule