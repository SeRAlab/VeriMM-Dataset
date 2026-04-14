module top_module(
  input [n-1:0] in,
  output out
);parameter n = 4; // number of input signals
parameter sensor_type = "capacitive"; // type of touch sensor interface, either "capacitive" or "resistive"

reg [n-1:0] in_prev;
reg touch_detected;

always @(*) begin
  if (sensor_type == "capacitive") begin
    // Capacitive touch sensor interface
    // Measure change in capacitance caused by presence of conductive object
    // Compare current input signals with previous input signals to detect change
    if (in != in_prev) begin
      touch_detected = 1;
    end else begin
      touch_detected = 0;
    end
  end else begin
    // Resistive touch sensor interface
    // Measure change in resistance caused by pressure of conductive object
    // Compare current input signals with threshold values to detect pressure
    if (in[0] > 0 && in[1] > 0 && in[2] > 0 && in[3] > 0) begin
      touch_detected = 1;
    end else begin
      touch_detected = 0;
    end
  end
  in_prev = in;
end

assign out = touch_detected;

endmodule