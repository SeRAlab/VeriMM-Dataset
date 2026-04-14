module top_module(
  input clk,
  input reset,
  input enable,
  input [3:0] attempt_count,
  output locked
);reg [3:0] counter;
  reg locked_status;

  always @(posedge clk) begin
    if (reset) begin
      counter <= 4'b0000;
      locked_status <= 1'b0;
    end else if (enable) begin
      counter <= counter + 1;
      if (counter >= 4'b1010) begin
        locked_status <= 1'b1;
      end else begin
        locked_status <= 1'b0;
      end
    end else begin
      locked_status <= 1'b0;
    end
  end

  assign locked = locked_status;

endmodule