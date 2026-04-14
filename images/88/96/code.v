module top_module(
  input clk,
  output reg [1:0] leds
);reg [19:0] counter = 0;

always @(posedge clk) begin
  counter <= counter + 1;
  if (counter == 1000000) begin
    counter <= 0;
    leds <= ~leds;
  end
end

endmodule