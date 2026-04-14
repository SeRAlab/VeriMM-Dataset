module top_module(
             input clk,
             input d,
             input rst_n,
             output logic q);always @ (posedge clk or negedge rst_n) begin
      if (!rst_n) q <= 1'b0;
      else q <= d;
   end
endmodule