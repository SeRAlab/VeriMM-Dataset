module top_module(
  input photo,
  input [k-1:0] ctrl,
  output light
);parameter k = 4; // number of control signals
parameter threshold = 8'h80; // threshold ambient light level
parameter max_brightness = 8'hFF; // maximum brightness level

reg [7:0] brightness;

always @(*) begin
  if (photo < threshold) begin
    brightness = max_brightness;
  end else begin
    brightness = (ctrl * max_brightness) / ((1 << k) - 1);
  end
end

assign light = brightness;

endmodule