module top_module(
   input wire data_in,
   output reg [7:0] data_out,
   input wire clk,
   input wire rst
   );always @(posedge clk) begin
      if (rst) begin
         data_out <= 8'b0;
      end
      else begin
         data_out <= {data_out[6:0], data_in};
      end
   end

endmodule