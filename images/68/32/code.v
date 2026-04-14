module top_module(
  input clk,                    // Added clock input
  input [n-1:0] data_in,
  output reg [m-1:0] LED
);parameter n = 8; // number of bits in the data_in signal
parameter m = 4; // number of LEDs to be driven by the circuit

reg [m-1:0] LED_mux; // multiplexed LED output
integer i; // Declare integer for loop iteration

always @ (posedge clk) begin
  for (i = 0; i < m; i = i + 1) begin
    LED_mux[i] <= data_in[i];
  end
end

always @ (posedge clk) begin
  for (i = 0; i < m; i = i + 1) begin
    LED[i] <= LED_mux[i];
  end
end

endmodule