module top_module(
  input clk_in,
  input reset,
  output reg clk_out
);parameter divide_by = 2;

reg [31:0] counter;

always @(posedge clk_in or posedge reset) begin
  if (reset) begin
    clk_out <= 1'b0;
    counter <= 0;
  end
  else begin
    if (counter == divide_by - 1) begin
      clk_out <= ~clk_out;
      counter <= 0;
    end
    else begin
      counter <= counter + 1;
    end
  end
end

endmodule