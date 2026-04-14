module top_module(
  input clk,
  input rst_n,
  output reg por_n
);parameter POR_WIDTH = 100000; // POR pulse width in clock cycles (e.g., 100ms at 1MHz clock)

reg [31:0] counter;

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    counter <= 0;
    por_n <= 1'b0;
  end else begin
    counter <= counter + 1;
    if (counter >= POR_WIDTH) begin
      por_n <= 1'b1;
    end
  end
end

endmodule