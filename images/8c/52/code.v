module top_module(
  input clk,                             // Declare the clock input
  input [n-1:0] in,
  output reg [7:0] out                 // Change output type to reg
);parameter n = 4; // number of input signals
parameter m = 1; // number of output signals

reg [n-1:0] in_reg; // input register
reg [7:0] count; // counter for energy conversion process
reg [7:0] energy; // energy accumulator
reg [7:0] voltage; // output voltage
integer i; // Declare loop variable i

// Initialize registers
initial begin
  count = 0;
  energy = 0;
  voltage = 0;
end

// energy conversion process
always @ (posedge clk) begin
  if (count == 0) begin
    energy <= 0;
    for (i = 0; i < n; i = i + 1) begin
      energy <= energy + in_reg[i]; // It's better to accumulate in a temporary value
    end
  end
  count <= count + 1;
end

// output voltage calculation
always @ (posedge clk) begin
  if (count == 255) begin
    voltage <= energy / n;
    if (voltage > 255) begin
      voltage <= 255;
    end
    out <= voltage;
  end
end

endmodule