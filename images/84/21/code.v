module top_module(
  input clk,
  input reset,
  output reg [1:0] output_signal
);reg [2:0] counter;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= 0;
      output_signal <= 0;
    end
    else begin
      counter <= counter + 1;
      output_signal <= counter[1:0];
    end
  end

endmodule