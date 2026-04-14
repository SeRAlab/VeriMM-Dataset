module top_module(
  input clock,
  input reset,
  output reg [3:0] counter_output
);always @(posedge clock) begin
    if (reset) begin
      counter_output <= 4'b0000;
    end else begin
      counter_output <= counter_output + 1;
    end
  end

endmodule