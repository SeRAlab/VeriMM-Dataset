module bit_checker (
   input [15:0] in,
   output reg out
);

   always @* begin
      out = |in;
   end

endmodule