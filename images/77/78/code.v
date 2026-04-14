module top_module(
  input [n-1:0] ctrl,
  input [7:0] data_in,
  output [n-1:0] data_out
);parameter n = 4; // number of control signals
parameter r = 1000; // total resistance of potentiometer
parameter w = 127; // wiper position of potentiometer (range: 0-255)

reg [n-1:0] resistance;

always @(*) begin
  // Calculate the resistance based on the wiper position and control signals
  resistance = (data_in * ctrl) / 255;
  
  // Scale the resistance to the total resistance of the potentiometer
  resistance = (resistance * r) / 255;
end

assign data_out = resistance;

endmodule