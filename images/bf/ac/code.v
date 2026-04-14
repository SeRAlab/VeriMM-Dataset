module top_module(
  input clk,
  input reset,
  output reg [2:0] counter
);always @(posedge clk, posedge reset) begin
    if (reset) begin
      counter <= 3'b0;
    end else if (counter == 3'b111) begin
      counter <= 3'b0;
    end else begin
      counter <= counter + 1;
    end
  end

endmodule