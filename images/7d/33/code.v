module top_module(
  input [3:0] input_data,
  input reset,
  output reg [2:0] output_data
);always @(input_data, reset) begin
  if (reset) begin
    output_data <= 3'b000;
  end else begin
    output_data <= {1'b0, input_data[3:1]};
  end
end

endmodule