module top_module(
   input wire clock,
   input wire reset,
   input wire count,
   output reg [(Size) - ('b1):0] data_o
);parameter Size = 8;

   always @ (posedge clock) begin
      if (reset) begin
         data_o <= {Size{1'b0}};
      end
      else begin
         if (count) begin
            data_o <= data_o + 1;
         end
      end
   end

endmodule