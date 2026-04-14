module top_module(
   input clk,
   input reset,
   input data_in,
   output reg data_out,
   output reg valid_out
   );reg data_in_delayed;

   always @(posedge clk) begin
      if (reset) begin
         data_out <= 1'b0;
         valid_out <= 1'b0;
         data_in_delayed <= 1'b0;
      end
      else begin
         data_out <= data_in_delayed;
         valid_out <= (data_out != data_in_delayed);
         data_in_delayed <= data_in;
      end
   end

endmodule