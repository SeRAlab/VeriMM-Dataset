module top_module(
  input clk,
  input reset,
  input [31:0] module_to_check_timeunit,
  output reg valid_timeunit
);reg [31:0] counter;

  always @(posedge clk) begin
    if (reset) begin
      valid_timeunit <= 0;
      counter <= 0;
    end else begin
      if (module_to_check_timeunit >= 10000) begin
        valid_timeunit <= 1;
      end else begin
        valid_timeunit <= 0;
      end
      counter <= counter + 1;
    end
  end

endmodule