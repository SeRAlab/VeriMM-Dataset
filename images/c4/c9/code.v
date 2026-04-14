module reverse_last_two_bits (
   input clk,
   input [3:0] in,
   output reg [1:0] out
);

   always @(posedge clk) begin
      out <= {in[1:0], in[3:2]};
   end

endmodule