module top_module(
  input clk,                  // Added clock input
  input [n-1:0] touch_sensors,
  output reg [m-1:0] digital_outputs // Changed from wire to reg
);parameter n = 4; // number of touch sensor signals
parameter m = 2; // number of digital output signals

// Capacitive touch technology implementation
reg [n-1:0] touch_sensors_prev;
reg [m-1:0] digital_outputs_prev;
reg [m-1:0] digital_outputs_curr;

always @(*) begin
  digital_outputs_curr = touch_sensors ^ touch_sensors_prev; // Removed unnecessary braces
end

always @(posedge clk) begin
  touch_sensors_prev <= touch_sensors;
  digital_outputs_prev <= digital_outputs_curr;
  digital_outputs <= digital_outputs_curr; // digital_outputs can now be assigned as it's a reg
end

endmodule