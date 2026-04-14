module top_module(
  input clk, // clock signal
  input rst, // reset signal
  input cs, // chip select signal
  input [n-1:0] wiper, // digital potentiometer control signal
  output out // potentiometer output voltage
);parameter n = 8; // number of bits in the digital potentiometer
parameter r_total = 100; // total resistance of the potentiometer (in ohms)

reg [n-1:0] wiper_reg; // register to hold the wiper position
reg [n-1:0] r_array [0:2**n-1]; // resistor array
reg [n:0] r_total_reg; // register to hold the total resistance of the potentiometer
wire [n:0] v_out; // voltage at the wiper

// initialize the resistor array
integer i;
initial begin
  for (i = 0; i < 2**n; i = i + 1) begin
    r_array[i] = r_total/(2**n);
  end
end

// compute the total resistance of the potentiometer
always @* begin
  r_total_reg = r_total/(2**n) * wiper_reg;
end

// compute the voltage at the wiper
assign v_out = {1'b0, r_total_reg} * wiper_reg;

// output the voltage at the wiper
assign out = v_out[n:1];

// control the wiper position
always @(posedge clk) begin
  if (rst) begin
    wiper_reg <= 0;
  end else if (cs) begin
    wiper_reg <= wiper;
  end
end

endmodule