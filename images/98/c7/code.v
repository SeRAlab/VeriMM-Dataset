module top_module(ctl, a, b, result, zero);input [2:0] ctl;
  input [31:0] a, b;
  output [31:0] result;
  output zero;

  reg [31:0] result;
  reg zero;

  always @(a or b or ctl)
  begin
    case (ctl)
      3'b000 : result = a & b; 
      3'b001 : result = a | b; 
      3'b010 : result = a + b; 
      3'b110 : result = a - b; 
      3'b111 : if (a < b) result = 32'd1; 
               else result = 32'd0; 
      default : result = 32'hxxxxxxxx;
   endcase
   if (result == 32'd0) zero = 1;
   else zero = 0;
 end
endmodule