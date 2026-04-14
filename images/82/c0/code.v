module top_module(
  input clk,
  output reg green,
  output reg yellow,
  output reg red
);parameter GREEN_TIME = 500_000_000; // 10 seconds
parameter YELLOW_TIME = 100_000_000; // 2 seconds
parameter RED_TIME = 400_000_000; // 8 seconds

reg [31:0] counter;

always @(posedge clk) begin
  if (counter < GREEN_TIME) begin
    green <= 1;
    yellow <= 0;
    red <= 0;
  end else if (counter < GREEN_TIME + YELLOW_TIME) begin
    green <= 0;
    yellow <= 1;
    red <= 0;
  end else if (counter < GREEN_TIME + YELLOW_TIME + RED_TIME) begin
    green <= 0;
    yellow <= 0;
    red <= 1;
  end else begin
    counter <= 0;
  end
  counter <= counter + 1;
end

endmodule