module top_module(
                      input valid_in44,
                      input clk_8f,
                      input reset,
                      output reg valid_inF
                      );always @ (posedge clk_8f) begin
      if (!reset) begin
         valid_inF <= 0;
      end else begin
         valid_inF <= valid_in44;
      end
   end

endmodule