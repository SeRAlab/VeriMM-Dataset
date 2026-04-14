module top_module(
  input clk,
  input in,
  output reg pulse
);reg prev_in;

always @(posedge clk) begin
  if (in && !prev_in) begin // rising edge detection
    pulse <= 1;
  end else if (!in && prev_in) begin // falling edge detection
    pulse <= 1;
  end else begin
    pulse <= 0;
  end
  prev_in <= in;
end

endmodule