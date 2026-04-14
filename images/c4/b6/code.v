module bus_hold (
  input [n-1:0] bus_in,
  input clk,
  input reset,
  output [n-1:0] bus_out
);

parameter n = 8; // number of bits in the bus signal

reg [n-1:0] bus_hold_reg; // register to hold the bus signal

always @(posedge clk) begin
  if (reset) begin
    bus_hold_reg <= 0;
  end else begin
    bus_hold_reg <= bus_in;
  end
end

assign bus_out = reset ? 0 : bus_hold_reg;

endmodule