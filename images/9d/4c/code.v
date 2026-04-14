module top_module(
  input wire clk,          // Added clk input
  output reg rst
);parameter width = 10; // width of reset signal
parameter delay = 5;  // delay before reset is released

reg [31:0] counter;
reg delay_line;

always @(posedge clk) begin
  if (counter < width) begin
    counter <= counter + 1;
    rst <= 1'b1;
  end else if (delay_line) begin
    rst <= 1'b0;
  end
end

always @(posedge clk) begin
  if (counter == delay) begin
    delay_line <= 1'b1;
  end else if (counter == width) begin
    delay_line <= 1'b0;
    counter <= 0;
  end
end

endmodule