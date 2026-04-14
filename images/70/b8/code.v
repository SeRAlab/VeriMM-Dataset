module top_module(
  input clk, // clock signal
  input trigger, // trigger signal
  input [7:0] width, // width of the output pulse
  output reg pulse_out // output pulse
);reg [7:0] count; // counter for pulse width

  always @(posedge clk) begin
    if (trigger) begin
      pulse_out <= 1'b1;
      count <= width;
    end else if (count > 0) begin
      pulse_out <= 1'b1;
      count <= count - 1;
    end else begin
      pulse_out <= 1'b0;
    end
  end

endmodule