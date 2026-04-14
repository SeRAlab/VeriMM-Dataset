module mux_2to1 (sel, a, b, y);
   input sel;
   input [15:0] a, b;
   output reg [15:0] y;

   always @(*) begin
      case (sel)
         1'b0: y = a;
         1'b1: y = b;
         default: y = 16'b0000000000000000;
      endcase
   end
endmodule