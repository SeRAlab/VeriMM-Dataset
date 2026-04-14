module top_module(
  input clk,         // Added clk input
  input start,
  input stop,
  output reg [n-1:0] tdc
);parameter n = 8; // number of bits in the digital signal

reg [n-1:0] counter;
reg counting;

always @(posedge clk) begin
  if (counting) begin
    counter <= counter + 1;
  end
end

always @(posedge clk) begin
  if (start && !counting) begin
    counter <= 0;
    counting <= 1;
  end else if (stop && counting) begin
    counting <= 0;
    tdc <= counter;
  end
end

endmodule