module top_module(
  input clk_in,
  input reset,
  output reg clk_out
);parameter N = 2; // division factor

reg [N-1:0] counter;

always @(posedge clk_in or posedge reset) begin
  if (reset) begin
    clk_out <= 1'b0;
    counter <= 0;
  end else begin
    if (counter == N-1) begin
      clk_out <= ~clk_out;
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end
  end
end

endmodule