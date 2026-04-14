module top_module(
  input light,
  input brightness,
  output reg dimmed_brightness
);parameter sensitivity = 10; // sensitivity of the light sensor

reg [7:0] ambient_light_level;

always @(*) begin
  ambient_light_level = light / sensitivity; // convert light sensor signal to ambient light level
end

always @(*) begin
  if (ambient_light_level > brightness) begin
    dimmed_brightness = brightness; // if ambient light level is higher than desired brightness, set dimmed brightness to desired brightness
  end else begin
    dimmed_brightness = ambient_light_level; // otherwise, set dimmed brightness to ambient light level
  end
end

endmodule