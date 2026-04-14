module top_module(
  input clk,        // Added clk input
  input start,
  input stop,
  output reg [31:0] elapsed_time
);reg [31:0] counter = 0;
  reg counting = 0;

  always @(posedge clk) begin
    if (start) begin
      counter <= 0;
      counting <= 1;
    end else if (stop) begin
      counting <= 0;
      elapsed_time <= counter;
    end else if (counting) begin
      counter <= counter + 1;
    end
  end

endmodule