module top_module(
  input clk,
  input rst,
  output reg red,
  output reg yellow,
  output reg green
);parameter GREEN_TIME = 15_000_000; // 15 seconds at 50MHz
parameter YELLOW_TIME = 3_000_000; // 3 seconds at 50MHz
parameter RED_TIME = 12_000_000; // 12 seconds at 50MHz

reg [23:0] counter; // 24-bit counter for timing

always @(posedge clk) begin
  if (rst) begin
    counter <= 0;
    red <= 1'b0;
    yellow <= 1'b0;
    green <= 1'b1;
  end
  else begin
    counter <= counter + 1;
    if (counter >= GREEN_TIME && counter < GREEN_TIME + YELLOW_TIME) begin
      green <= 1'b0;
      yellow <= 1'b1;
    end
    else if (counter >= GREEN_TIME + YELLOW_TIME && counter < GREEN_TIME + YELLOW_TIME + RED_TIME) begin
      yellow <= 1'b0;
      red <= 1'b1;
    end
    else if (counter >= GREEN_TIME + YELLOW_TIME + RED_TIME) begin
      red <= 1'b0;
      green <= 1'b1;
      counter <= 0;
    end
  end
end

endmodule