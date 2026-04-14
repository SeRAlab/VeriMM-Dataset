module top_module(
  input clk,
  input reset,
  input signed [31:0] input_data,
  output reg signed [31:0] output_data,
  output reg valid
);always @(posedge clk) begin
    if (reset) begin
      output_data <= 0;
      valid <= 0;
    end else begin
      if (input_data >= 0) begin
        output_data <= input_data + 1;
        valid <= 1;
      end else begin
        output_data <= input_data - 1;
        valid <= 1;
      end
    end
  end

endmodule