module top_module(
  input clk,
  input [2:0] addr,
  input [6:0] data,
  output reg [7:0] vout
);parameter rmax = 10000; // maximum resistance value
parameter rstep = 1000; // resistance step size
parameter initial_pos = 0; // initial wiper position

reg [6:0] resistances [0:7]; // array to store resistance values
integer i;

always @(posedge clk) begin
  resistances[addr] <= data; // update the resistance value at the selected wiper position
end

always @(posedge clk) begin
  // calculate the voltage output based on the selected wiper position and resistance value
  vout <= (resistances[addr] * 255) / rmax;
end

initial begin
  // initialize the potentiometer with the initial resistance value at the initial wiper position
  for (i = 0; i < 8; i = i + 1) begin
    resistances[i] = (i == initial_pos) ? (rstep * initial_pos) : 0;
  end
end

endmodule