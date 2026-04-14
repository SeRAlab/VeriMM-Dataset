module top_module(input data_in, clk, output reg data_out);always @(posedge clk) begin
  data_out <= data_in;
end

endmodule