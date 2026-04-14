module top_module(
   input [7:0] a,
   input [7:0] b,
   input [3:0] ctrl,
   output reg signed [15:0] p
);always @(*) begin
      case (ctrl)
         4'b0000: p = $signed(a) * $signed(b);
         4'b0001: p = $signed(a) * $signed(b) + 1;
         4'b0010: p = $signed(a) * $signed(b) - 1;
         4'b0011: p = $signed(a) * $signed(b) + $signed(a);
         4'b0100: p = $signed(a) * $signed(b) - $signed(a);
         4'b0101: p = $signed(a) * $signed(b) + $signed(b);
         4'b0110: p = $signed(a) * $signed(b) - $signed(b);
         4'b0111: p = $signed(a) * $signed(b) + $signed(a) + $signed(b);
         4'b1000: p = $signed(a) * $signed(b) - $signed(a) - $signed(b);
         default: p = 0;
      endcase
      
      if (p > 32767) // saturation to maximum value
         p = 32767;
      else if (p < -32768) // saturation to minimum value
         p = -32768;
   end

endmodule