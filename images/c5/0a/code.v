module pulse_gen(
  input clk,
  input trigger,
  input [15:0] pulse_width,
  output reg pulse
);

reg [15:0] counter = 0;
reg pulse_gen = 0;

always @(posedge clk) begin
  if (trigger) begin
    pulse_gen <= 1;
    counter <= 0;
  end else begin
    if (counter >= pulse_width) begin
      pulse_gen <= 0;
    end
    counter <= counter + 1;
  end
end

always @(posedge clk) begin
  pulse <= pulse_gen;
end

endmodule