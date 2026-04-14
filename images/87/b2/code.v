module top_module(
   input logic clock,
   input logic resetn,
   input logic [63:0] vector1,
   input logic [63:0] vector2,
   output logic [63:0] result_vector
);always_ff @(posedge clock) begin
      if (resetn == 1'b0) begin
         result_vector <= 'b0;
      end else begin
         result_vector <= vector1 + vector2;
      end
   end

endmodule