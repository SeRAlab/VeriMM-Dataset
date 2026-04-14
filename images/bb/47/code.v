module top_module(
  input [n-1:0] ctrl,
  input [m-1:0] sel,
  output reg resistance
);parameter n = 3; // number of control signals
parameter m = 4; // number of select signals
parameter R = 100; // resistance range in ohms (0 to R)

reg [n-1:0] binary_resistance; // binary representation of the resistance
reg [m-1:0] wiper_position; // wiper position of the potentiometer

// Calculate the binary resistance based on the control signals
always @(*) begin
  binary_resistance = ctrl;
end

// Calculate the wiper position based on the select signals
always @(*) begin
  wiper_position = sel;
end

// Calculate the resistance based on the binary resistance and wiper position
always @(*) begin
  resistance = (binary_resistance * (wiper_position / (m-1))) * (R / ((2**n)-1));
end

endmodule