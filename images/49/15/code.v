module top_module(
  input [n-1:0] ctrl,
  input [wiper_width-1:0] wiper_pos,
  output [resistance_width-1:0] resistance
);parameter n = 4; // number of control signals
parameter rmax = 100; // maximum resistance value
parameter rstep = 1; // resistance step size

localparam wiper_width = $clog2(rmax); // Width of the wiper_pos input
localparam resistance_width = wiper_width; // Assuming the resistance output is the same width as wiper_pos

reg [resistance_width-1:0] resistance_value;

always @(*) begin
  resistance_value = (wiper_pos * rstep) + (ctrl * (rmax / (2**n-1)));
end

assign resistance = resistance_value;

endmodule