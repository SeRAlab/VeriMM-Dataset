module top_module(
  input in_signal,
  input [3:0] constant_value,
  output reg [3:0] out_signal
);always @(*) begin
  if (in_signal) begin
    out_signal = constant_value;
  end
  else begin
    out_signal = 4'b0000;
  end
end

endmodule